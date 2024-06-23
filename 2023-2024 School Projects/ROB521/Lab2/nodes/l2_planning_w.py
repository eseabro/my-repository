#!/usr/bin/env python3
#Standard Libraries
import numpy as np
import yaml
import pygame
import time
import pygame_utils
import matplotlib.image as mpimg
from skimage.draw import disk
from scipy.linalg import block_diag
import random


def load_map(filename):
    im = mpimg.imread("../maps/" + filename)
    if len(im.shape) > 2:
        im = im[:,:,0]
    im_np = np.array(im)  #Whitespace is true, black is false
    #im_np = np.logical_not(im_np)    
    return im_np


def load_map_yaml(filename):
    with open("../maps/" + filename, "r") as stream:
            map_settings_dict = yaml.safe_load(stream)
    return map_settings_dict

#Node for building a graph
class Node:
    def __init__(self, point, parent_id, cost):
        self.point = point # A 3 by 1 vector [x, y, theta]
        self.parent_id = parent_id # The parent node id that leads to this node (There should only every be one parent in RRT)
        self.cost = cost # The cost to come to this node
        self.children_ids = [] # The children node ids of this node
        return

#Path Planner 
class PathPlanner:
    #A path planner capable of perfomring RRT and RRT*
    def __init__(self, map_filename, map_setings_filename, goal_point, stopping_dist):
        #Get map information
        self.occupancy_map = load_map(map_filename)
        self.map_shape = self.occupancy_map.shape
        self.map_settings_dict = load_map_yaml(map_setings_filename)

        #Get the metric bounds of the map
        self.bounds = np.zeros([2,2]) #m
        self.bounds[0, 0] = self.map_settings_dict["origin"][0]
        self.bounds[1, 0] = self.map_settings_dict["origin"][1]
        self.bounds[0, 1] = self.map_settings_dict["origin"][0] + self.map_shape[1] * self.map_settings_dict["resolution"]
        self.bounds[1, 1] = self.map_settings_dict["origin"][1] + self.map_shape[0] * self.map_settings_dict["resolution"]

        #Robot information
        self.robot_radius = 0.22 #m
        self.vel_max = 1 #0.5 #m/s (Feel free to change!)
        self.rot_vel_max = 2*np.pi #rad/s (Feel free to change!)
        self.sample_radius = 0

        #Goal Parameters
        self.goal_point = goal_point #m
        self.stopping_dist = stopping_dist #m

        # Trajectory Simulation Parameters
        self.timestep = 1.0 #s
        self.num_substeps = int(self.vel_max*self.timestep/self.map_settings_dict["resolution"])

        #Planning storage
        self.nodes = [Node([0,0,0], -1, 0)]

        #RRT* Specific Parameters
        self.lebesgue_free = np.sum(self.occupancy_map) * self.map_settings_dict["resolution"] **2
        self.zeta_d = np.pi
        self.gamma_RRT_star = 2 * (1 + 1/2) ** (1/2) * (self.lebesgue_free / self.zeta_d) ** (1/2)
        self.gamma_RRT = self.gamma_RRT_star + .1
        self.epsilon = 2.5
        
        #Pygame window for visualization
        self.window = pygame_utils.PygameWindow(
            "Path Planner", (800, 800), self.occupancy_map.shape, self.map_settings_dict, self.goal_point, self.stopping_dist)
        return

    # #Functions required for RRT
    def sample_map_space(self):
        #Return an [x,y] coordinate to drive the robot towards
        margin = 10
        o_margin = 20
        lmargin = 5
        x_vals = np.linspace(self.bounds[0,0]+o_margin, self.bounds[0,1]-margin, self.map_shape[0])
        y_vals = np.linspace(self.bounds[1,0]+lmargin, self.bounds[1,1]-o_margin, self.map_shape[1])
        x_vals_sm = np.linspace(0-lmargin, 0+o_margin, self.map_shape[0])
        y_vals_sm = np.linspace(0-o_margin, 0+lmargin, self.map_shape[1])
        x_vals_sm2 = np.linspace(self.goal_point[0][0]-margin, self.goal_point[0][0]+lmargin, self.map_shape[0])
        y_vals_sm2 = np.linspace(self.goal_point[1][0]-lmargin, self.goal_point[1][0]+margin, self.map_shape[1])
        x, y = 0, 0
        while self.check_if_duplicate([x,y]):
            if self.sample_radius < 500:
                x = random.choice(x_vals_sm)
                y = random.choice(y_vals_sm)
                self.sample_radius +=1
            elif self.sample_radius < 5000:
                x = random.choice(x_vals)
                y = random.choice(y_vals)
                self.sample_radius +=1
            else:
                x = random.choice(x_vals_sm2)
                y = random.choice(y_vals_sm2)
        return x, y
    
    def check_if_duplicate(self, point):
        #Check if point is a duplicate of an already existing node
        # print("Done")
        existing_nodes = [list(n.point[:2]) for n in self.nodes]
        dup = (point in existing_nodes)
        return dup
    
    def closest_node(self, point):
        #Returns the index of the closest node
        try:
            dists = [self.eucl_distance(x.point,point) for x in self.nodes]
            closest_ind = np.argmin(dists)
            o = self.nodes[int(closest_ind)]
        except:
            print(closest_ind)
            print(len(self.nodes))
            raise
        return o
    
    def simulate_trajectory(self, node_i, point_s):
        #Simulates the non-holonomic motion of the robot.
                
        vel, rot_vel = self.robot_controller(node_i, point_s)
        robo_traj = self.trajectory_rollout(vel, rot_vel, node_i, point_s)
        # robo_traj = np.transpose(robot_traj)

        return robo_traj
    
    def robot_controller(self, node_i, point_s):
        """
        Arguments:
            node_i = [x, y, theta]
            point_s = [x, y]
        """
        #This controller determines the velocities that will nominally move the robot from node i to node s
        #Max velocities should be enforced

        d_x0 = point_s[0] - node_i.point[0]
        d_y0 = point_s[1] - node_i.point[1]
        theta_diff = np.arctan2(d_y0, d_x0)

        if abs(theta_diff) > self.rot_vel_max*self.timestep/self.num_substeps:
            if theta_diff > 0 :
                ang_vel = self.rot_vel_max
            elif theta_diff < 0:
                ang_vel = -self.rot_vel_max
            else:
                ang_vel = 0
        else:
            ang_vel = theta_diff*self.num_substeps/self.timestep

        lat_vel = np.sqrt(d_x0**2 + d_y0**2)/(self.timestep)

        if abs(lat_vel) > self.vel_max:
            lat_vel = self.vel_max

        return lat_vel, ang_vel
    
    def trajectory_rollout(self, vel, rot_vel, node, pt):
        # Given your chosen velocities determine the trajectory of the robot for your given timestep
        # The returned trajectory should be a series of points to check for collisions
        """
        I'm assuming vel is [x, y, z] and rot_vel is [u, v, w]
        """

        [x0, y0, theta0] = node.point

        x = x0
        y = y0
        theta = theta0
        out = []
        d_x0 = pt[0] - x0
        d_y0 = pt[1] - y0
        theta_final = np.arctan2(d_y0, d_x0)

        for i in range(self.num_substeps):
            d_theta = theta_final - theta
            d_x = pt[0] - x
            d_y = pt[1] - y

            if ((abs(rot_vel) == self.rot_vel_max) and (abs(d_theta) >= (self.rot_vel_max*self.timestep/self.num_substeps))) or ((abs(rot_vel) != self.rot_vel_max) and (abs(d_theta) >= 0.001)):
                theta = theta + rot_vel*self.timestep/self.num_substeps
            else:
                if (abs(d_x) >= 1) or (abs(d_y) >= 1):
                    x = x + vel*self.timestep*np.cos(theta)/self.num_substeps
                    y = y + vel*self.timestep*np.sin(theta)/self.num_substeps
            out.append([x,y,theta])
        

        if abs(d_x0) < self.vel_max*self.timestep:
            x_n = np.linspace(node.point[0], pt[0], self.num_substeps)
        elif pt[0] >= node.point[0]:
            x_n = np.linspace(node.point[0], node.point[0]+self.vel_max*self.timestep, self.num_substeps)
        else:
            x_n = np.linspace(node.point[0], node.point[0]-self.vel_max*self.timestep, self.num_substeps)

        if abs(d_y0) < self.vel_max*self.timestep:
            y_n = np.linspace(node.point[1], pt[1], self.num_substeps)
        elif pt[1] >= node.point[1]:
            y_n = np.linspace(node.point[1], node.point[1]+self.vel_max*self.timestep, self.num_substeps)

        else:
            y_n = np.linspace(node.point[1], node.point[1]-self.vel_max*self.timestep, self.num_substeps)


        t_n = np.zeros(self.num_substeps)

        out2 = np.array([x_n, y_n, t_n])




        # print(node.point)
        # print(pt)
        # print(out)

        return out2
    
    def point_to_cell(self, point):
        #Convert a series of [x,y] points in the map to the indices for the corresponding cell in the occupancy map
        #point is a 2 by N matrix of points of interest
        res = self.map_settings_dict["resolution"]

        x = point[0] - self.map_settings_dict["origin"][0]
        y = point[1] - self.map_settings_dict["origin"][1]

        h = self.map_shape[1] * res

        x_new = self.map_shape[1] - int(y/res)
        y_new = int(x/res)

        return x_new, y_new

    def points_to_robot_circle(self, points):
        #Convert a series of [x,y] points to robot map footprints for collision detection
        #Hint: The disk function is included to help you with this function
        out_rr = []
        out_cc = []
        for pt in points:
            cc = self.point_to_cell(pt)
            if (cc[0]>self.map_shape[0]) or (cc[1] > self.map_shape[1]) or (cc[0]<0) or (cc[1]<0):
                return [], []
            d_rr, d_cc = disk(cc, self.robot_radius, shape=self.map_shape)
            if (d_rr.size == 0) or (d_cc.size == 0):
                print(pt)
                raise
            out_rr.append(d_rr)
            out_cc.append(d_cc)
        return out_rr, out_cc
    #Note: If you have correctly completed all previous functions, then you should be able to create a working RRT function

    #RRT* specific functions
    def ball_radius(self):
        # Close neighbor distance
        card_V = len(self.nodes)
        return min(self.gamma_RRT * (np.log(card_V) / card_V ) ** (1.0/2.0), self.epsilon)
    
    def connect_node_to_point(self, node_i, point_f):
        #Given two nodes find the non-holonomic path that connects them
        #Settings
        #node is a 3 by 1 node
        #point is a 2 by 1 point
        x_res = y_res = self.map_settings_dict["resolution"]/2
        x_node, y_node, _ = node_i.point
        x_goal, y_goal = point_f

        if x_goal < x_node:
            x_res = -x_res
        if y_goal < y_node:
            y_res = -y_res

        x_pts = np.arange(x_node, x_goal, x_res)
        y_pts = np.arange(y_node, y_goal, y_res)
        t_pts = np.zeros((1,len(x_pts)))

        return [x_pts, y_pts, t_pts]
    
    def cost_to_come(self, trajectory_o):
        #The cost to get to a node from lavalle 
        dx = trajectory_o[0][-1] - trajectory_o[0][0]
        dy = trajectory_o[1][-1] - trajectory_o[1][0]

        return np.sqrt(dx**2 + dy**2)
    
    def update_children(self, node_id):
        #Given a node_id with a changed cost, update all connected nodes with the new cost
        for j, child in enumerate(self.nodes):
            if child.parent_id == node_id:
                traj = self.simulate_trajectory(node_id, child.point)
                cost_new = self.cost_to_come(traj)
                self.nodes[j].cost = node_id.cost + cost_new
                self.nodes[j].parent_id = node_id
        return None
    
    def check_for_collisions(self, path_pts):
        collide = False
        for p in path_pts:
            if p < self.map_settings_dict['occupied_thresh']:
                collide = True                

        return collide

    #Planner Functions
    def rrt_planning(self):
        for i in range(50000): #Most likely need more iterations than this to complete the map!
            #Sample
            pygame.event.pump()
            point = self.sample_map_space()
            # self.window.add_point(list(point))

            # input("test ")

            #Closest Node
            closest_node_id = self.closest_node(list(point))
            # print("Closest Node:", closest_node_id.point, '\n')

            #Simulate trajectory
            trajectory_o = self.simulate_trajectory(closest_node_id, point)
            # print("Trajectory: ", trajectory_o, '\n')

            #Check for Collision
            [x, y, theta] = trajectory_o
            out_rr, out_cc = self.points_to_robot_circle(zip(x,y))
            if out_rr == [] or out_cc == []:
                continue
            try:
                path_pts = self.occupancy_map[out_rr, out_cc]
            except Exception as e:
                print(out_rr)
            collide = self.check_for_collisions(path_pts)
            if collide:
                # self.window.add_line(closest_node_id.point[:2], [x[-1], y[-1]], color='red')
                continue
            else:
                new_pt = [x[-1], y[-1], theta[-1]]
                cost_new = self.cost_to_come(trajectory_o) + closest_node_id.cost
                new_node = Node(new_pt, closest_node_id, cost_new)
                self.nodes.append(new_node)
                # self.window.add_point(new_pt[:2])
        
            self.window.add_line(new_node.parent_id.point[:2], new_node.point[:2], color='blue')
            #Check for early end

            # Check for end: 
            goal = [self.goal_point[0][0], self.goal_point[1][0]]

            closest_node_id = self.closest_node(goal)
            # print("Closest Node:", closest_node_id.point, '\n')

            #Simulate trajectory
            trajectory_o = self.simulate_trajectory(closest_node_id, goal)
            # print("Trajectory: ", trajectory_o, '\n')

            #Check for Collision
            [x, y, theta] = trajectory_o
            out_rr, out_cc = self.points_to_robot_circle(zip(x,y))
            if out_rr == [] or out_cc == []:
                continue
            try:
                path_pts = self.occupancy_map[out_rr, out_cc]
            except Exception as e:
                print(out_rr)
            collide = self.check_for_collisions(path_pts)
            if collide:
                # self.window.add_line(closest_node_id.point[:2], [x[-1], y[-1]], color='red')
                continue
            else:
                new_pt = [x[-1], y[-1], theta[-1]]
                if self.eucl_distance(goal, new_pt[:2]) < self.stopping_dist:
                    cost_new = self.cost_to_come(trajectory_o) + closest_node_id.cost
                    new_node = Node(new_pt, closest_node_id, cost_new)
                    self.nodes.append(new_node)
                    print("Cost to goal: ", cost_new)
                    input("test: ")
                    break



        return self.nodes
    
    def rrt_star_planning(self):
        #This function performs RRT* for the given map and robot        
        for i in range(50000): #Most likely need more iterations than this to complete the map!
            #Sample
            pygame.event.pump()
            # if i%10 == 0:
            # print(self.bounds)
            # input("Continue? ")
            point = self.sample_map_space()
            # self.window.add_point(list(point))
            # print("Nodes: ", [x.point for x in self.nodes])
            # print("Sampled point: ", point, '\n')

            #Closest Node
            closest_node_id = self.closest_node(list(point))
            # print("Closest Node:", closest_node_id.point, '\n')

            #Simulate trajectory
            trajectory_o = self.simulate_trajectory(closest_node_id, point)
            # print("Trajectory: ", trajectory_o, '\n')

            #Check for Collision
            [x, y, theta] = trajectory_o
            out_rr, out_cc = self.points_to_robot_circle(zip(x,y))
            if out_rr == [] or out_cc == []:
                print('robot circle error')
                continue
            try:
                path_pts = self.occupancy_map[out_rr, out_cc]
            except Exception as e:
                print(out_rr)
            collide = self.check_for_collisions(path_pts)
            if collide:
                # self.window.add_line(closest_node_id.point[:2], [x[-1], y[-1]], color='red')
                continue
            else:
                new_pt = [x[-1], y[-1], theta[-1]]
                cost_new = self.cost_to_come(trajectory_o) + closest_node_id.cost
                new_node = Node(new_pt, closest_node_id, cost_new)
                self.nodes.append(new_node)
                # self.window.add_point(new_pt[:2])


            # Rewiring
            for i, neighbour_node in enumerate(self.nodes[:-1]):
                if self.eucl_distance(neighbour_node.point[:2], new_pt[:2]) < self.ball_radius():
                    traj = self.connect_node_to_point(neighbour_node, point)
                    x_n, y_n, _ = traj
                    n_rr, n_cc = self.points_to_robot_circle(zip(x_n, y_n))
                    if n_rr == [] or n_cc == []:
                        print('point to circle err')
                        continue
                    try:
                        path_pts = self.occupancy_map[n_rr, n_cc]
                    except Exception as e:
                        print(e)
                    if not self.check_for_collisions(path_pts):
                        cost_new = self.cost_to_come(traj) + new_node.cost
                        if cost_new < neighbour_node.cost:
                            self.nodes[i].cost = cost_new
                            self.nodes[i].parent_id = new_node
                            self.update_children(self.nodes[i])
        
            self.window.add_line(new_node.parent_id.point[:2], new_node.point[:2], color='blue')



            # Check for end: 
            goal = [self.goal_point[0][0], self.goal_point[1][0]]

            closest_node_id = self.closest_node(goal)
            # print("Closest Node:", closest_node_id.point, '\n')

            #Simulate trajectory
            trajectory_o = self.simulate_trajectory(closest_node_id, goal)
            # print("Trajectory: ", trajectory_o, '\n')

            #Check for Collision
            [x, y, theta] = trajectory_o
            out_rr, out_cc = self.points_to_robot_circle(zip(x,y))
            if out_rr == [] or out_cc == []:
                continue
            try:
                path_pts = self.occupancy_map[out_rr, out_cc]
            except Exception as e:
                print(out_rr)
            collide = self.check_for_collisions(path_pts)
            if collide:
                # self.window.add_line(closest_node_id.point[:2], [x[-1], y[-1]], color='red')
                continue
            else:
                new_pt = [x[-1], y[-1], theta[-1]]
                if self.eucl_distance(goal, new_pt[:2]) < self.stopping_dist:
                    cost_new = self.cost_to_come(trajectory_o) + closest_node_id.cost
                    new_node = Node(new_pt, closest_node_id, cost_new)
                    self.nodes.append(new_node)
                    print("Cost to goal: ", cost_new)
                    input("test: ")
                    break

        return self.nodes

    def eucl_distance(self, a, b):
        return np.sqrt((a[0] - b[0])**2 + (a[1] - b[1])**2)
    
    def recover_path(self, algo_type, node_id = -1):
        path = [self.nodes[node_id].point]
        current_node = self.nodes[node_id].parent_id
        while current_node.parent_id.point != [0,0,0]:
            self.window.add_line(current_node.parent_id.point[:2], current_node.point[:2], color='red')
            path.append(current_node.point)
            current_node = current_node.parent_id
        path.append([0,0,0])
        path.reverse()
        pygame.image.save(self.window.screen, f"C:/Users/Emma/Documents/SchoolWork/Fourth Year/ROB521/Lab2/nodes/algo_result_{algo_type}.jpeg")

        return path

def main():
    #Set map information
    map_filename = "willowgarageworld_05res.png"
    map_setings_filename = "willowgarageworld_05res.yaml"

    #robot information
    goal_point = np.array([[42], [-44]]) #m
    stopping_dist = 1 #m

    algo_type = "RRT_STAR"

    #RRT precursor
    path_planner = PathPlanner(map_filename, map_setings_filename, goal_point, stopping_dist)

    if algo_type == "RRT":
        nodes = path_planner.rrt_planning()
        
        np.array(path_planner.recover_path(algo_type))
        node_path_metric_rrt = np.array(path_planner.recover_path(algo_type))
        np.save("shortest_path_rrt.npy", node_path_metric_rrt)
        
    elif algo_type == "RRT_STAR":
        nodes = path_planner.rrt_star_planning()
        node_path_metric_rrt_star = np.array(path_planner.recover_path(algo_type))
        np.save("shortest_path_rrt_star.npy", node_path_metric_rrt_star)


if __name__ == '__main__':
    main()
