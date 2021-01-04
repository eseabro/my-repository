from lab1_utilities import *

#class MinHeap:
    #def __init__(self, array):
        #self.array = array
    
    #def enque(self, array, item):
        #return array.append(item)
    
    #def deque(self, array, item):
        #item
        #array.index
        #return 

def get_installations_from_file(file_name):
    """Parse the data from the .txt file to create and return a list of instances of lab1_utilities.Installation.
    Each line of the file represents a single installation, except for the heading. Each Installation instance
    should  have attributes [str]name, [int]ward,a  2-element [tuple](float, float) position(x,y), and [bool]indoors
    (True for indoor, False for outdoor.)
    """
    file = open(file_name, 'r')
    x = file.readline()
    art_insts = []
    art_insts_print = []
    for line in file:
        #print(line)
        line = line.strip('\n')
        line = line.split('\t')
        #print(line)
        if 'INDOORS' == line[-1]:
            x = True
        else:
            x = False
        line = Installation(line[0], int(line[2]), (float(line[7]), float(line[8])), x)
        art_insts.append(line)

    return art_insts


def euclidean_distance(position1, position2):
    # implement
    '''basically x^2 +y^2 rooted
    '''
    dist_x = abs(position2[0] - position1[0])
    dist_y = abs(position2[1] - position1[1])
    dist = (dist_x **2 + dist_y **2) ** 0.5
    return dist


def get_adjacency_mtx(installations):
    '''implement
    k = 1.0 if both art installations are outdoors
    k = 1.5if one or both art installations are indoors
    '''
    adjacency_matrix = []
    row_list = []
    for row in range(len(installations)):
        for column in range(len(installations)):
            if row == column:
                col = 0
            else:
                if abs(installations[column].ward - installations[row].ward) <= 1:
                    # print(row.indoor)
                    # print(column.indoor)
                    if installations[column].indoor == True or installations[row].indoor == True:
                        k = 1.5
                    else:
                        k = 1.0
                    col = k * euclidean_distance(installations[column].position, installations[row].position)
                else:
                    col = 0
            row_list.append(col)
        adjacency_matrix.append(row_list)
        row_list = []

    return adjacency_matrix


def make_graph(installations):
    
    connect = get_adjacency_mtx(installations)
    arts_list = []
    for arts in installations:
        arts_list.append(arts.name)
    graph_final = Graph(arts_list, connect)
    
    return graph_final

def my_min(arr, list_of_distances):
    smallest = float('inf')
    small_index = None
    if len(arr) == 1:
        return arr[0]
    for index in arr:
        if list_of_distances[index] < smallest:
            small_index = index
            smallest= list_of_distances[index]
    return small_index


def find_shortest_path(installation_A, installation_B, graph):
    list_of_installations = graph.installations
    list_of_distances = []
    #list of distances is indexed same as list of installations
    pat_taken = []
    distance = None
    nodes_to_visit = []
    final = []

    
    for installation in list_of_installations:
        #this is the part where i initialize everything to inf except A
        if installation != installation_A:
            list_of_distances.append(float('inf'))
        if installation == installation_A:
            list_of_distances.append(0)
        nodes_to_visit.append(list_of_installations.index(installation))
        pat_taken.append(None)
    
    old = None    

    while True:
        #print(nodes_to_visit)
        #print(list_of_distances)
        curr_index = my_min(nodes_to_visit, list_of_distances)
        #this finds the smallest distance


        if list_of_distances[curr_index] == float('inf'):
            solution = [distance, final]
            return solution
        nodes_to_visit.remove(curr_index)
        for nodes in list_of_installations:
            #this will run x times where x is the #of nodes
            col_index = list_of_installations.index(nodes)
            if graph.adjacency_mtx[curr_index][col_index] > 0:
                temp = list_of_distances[curr_index] + graph.adjacency_mtx[curr_index][col_index]
                if temp < list_of_distances[col_index]:
                    list_of_distances[col_index] = temp
                    if old != None:
                        pat_taken[col_index] = list_of_installations[curr_index]                    
                    #print(temp)
        old = curr_index
        if list_of_installations[curr_index] == installation_B:
            #print(list_of_distances)
            distance = list_of_distances[curr_index]
            #print(distance)
            break
    nu_curr = installation_B
    tempy = []
    #print(pat_taken)
    while True:
        tempy.append(nu_curr)
        mom = pat_taken[list_of_installations.index(nu_curr)]
        nu_curr = mom
        if nu_curr == None:
            break
        #print(tempy)
    #print(tempy)
    tempy.append(installation_A)
    tempy.reverse()
    #print(tempy)
    final = tempy
    #print(distance)
    solution = [distance, final]
    return solution