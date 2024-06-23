% =========
% ass3_q1.m
% =========
%
% This assignment will introduce you to the idea of first building an
% occupancy grid then using that grid to estimate a robot's motion using a
% particle filter.
% 
% There are two questions to complete (5 marks each):
%
%    Question 1: code occupancy mapping algorithm 
%    Question 2: see ass3_q2.m
%
% Fill in the required sections of this script with your code, run it to
% generate the requested plot/movie, then paste the plots into a short report
% that includes a few comments about what you've observed.  Append your
% version of this script to the report.  Hand in the report as a PDF file
% and the two resulting AVI files from Questions 1 and 2.
%
% requires: basic Matlab, 'gazebo.mat'
%
% T D Barfoot, January 2016
%
clear all;

% set random seed for repeatability
rng(1);

% ==========================
% load the dataset from file
% ==========================
%
%    ground truth poses: t_true x_true y_true theta_true
% odometry measurements: t_odom v_odom omega_odom
%           laser scans: t_laser y_laser
%    laser range limits: r_min_laser r_max_laser
%    laser angle limits: phi_min_laser phi_max_laser
%
load gazebo.mat;

% =======================================
% Question 1: build an occupancy grid map
% =======================================
%
% Write an occupancy grid mapping algorithm that builds the map from the
% perfect ground-truth localization.  Some of the setup is done for you
% below.  The resulting map should look like "ass2_q1_soln.png".  You can
% watch the movie "ass2_q1_soln.mp4" to see what the entire mapping process
% should look like.  At the end you will save your occupancy grid map to
% the file "occmap.mat" for use in Question 2 of this assignment.

% allocate a big 2D array for the occupancy grid
ogres = 0.05;                   % resolution of occ grid
ogxmin = -7;                    % minimum x value
ogxmax = 8;                     % maximum x value
ogymin = -3;                    % minimum y value
ogymax = 6;                     % maximum y value
ognx = (ogxmax-ogxmin)/ogres;   % number of cells in x direction
ogny = (ogymax-ogymin)/ogres;   % number of cells in y direction
oglo = zeros(ogny,ognx);        % occupancy grid in log-odds format
ogp = ones(ogny,ognx)*(0.5);         % occupancy grid in probability format

% precalculate some quantities
numodom = size(t_odom,1);
npoints = size(y_laser,2);
angles = linspace(phi_min_laser, phi_max_laser,npoints);
dx = ogres*cos(angles);
dy = ogres*sin(angles);

% interpolate the noise-free ground-truth at the laser timestamps
t_interp = linspace(t_true(1),t_true(numodom),numodom);
x_interp = interp1(t_interp,x_true,t_laser);
y_interp = interp1(t_interp,y_true,t_laser);
theta_interp = interp1(t_interp,theta_true,t_laser);
omega_interp = interp1(t_interp,omega_odom,t_laser);
  
% set up the plotting/movie recording
vid = VideoWriter('ass3_q1.avi');
open(vid);
figure(1);
clf;
pcolor(ogp);
colormap(1-gray);
shading('flat');
axis equal;
axis off;
M = getframe;
writeVideo(vid,M);

% loop over laser scans (every fifth)
for i=1:5:size(t_laser,1)
    
    % ------insert your occupancy grid mapping algorithm here------

    robot_pos_pix_x = (x_interp(i)-ogxmin)/ogres;
    robot_pos_pix_y = (y_interp(i)-ogymin)/ogres;

    % loop over laser scans
    for j = 1:size(angles,2)

        if (y_laser(i, j) < r_min_laser) || isnan(y_laser(i, j))
            y_laser(i, j) = r_min_laser;
        end
         
        if y_laser(i, j) > r_max_laser
             y_laser(i, j) = r_max_laser;
        end

        x_scan_pos = x_interp(i) + y_laser(i, j).*cos(theta_interp(i) + angles(j));
        y_scan_pos = y_interp(i) + y_laser(i, j).*sin(theta_interp(i) + angles(j));
        
        x_scan_pix = round((x_scan_pos-ogxmin)/ogres);
        y_scan_pix = round((y_scan_pos-ogymin)/ogres);
        
        if y_scan_pix > robot_pos_pix_y
            dty = 1;
        else
            dty = -1;
        end
        if x_scan_pix > robot_pos_pix_x
            dtx = 1;
        else
            dtx = -1;
        end

        if abs(x_scan_pix) > abs(y_scan_pix)
            diff = abs(x_scan_pix)*2;
        else
            diff = abs(y_scan_pix)*2;
        end
       
        mid_points_y = round(linspace(robot_pos_pix_y, y_scan_pix-2*dty, round(diff)));
        mid_points_x = round(linspace(robot_pos_pix_x, x_scan_pix-2*dtx, round(diff)));

        for p = 1:size(mid_points_y, 2)
            oglo(mid_points_y(p), mid_points_x(p)) = oglo(mid_points_y(p), mid_points_x(p)) - 1;
        end
        oglo(y_scan_pix, x_scan_pix) = oglo(y_scan_pix, x_scan_pix) +2;
    end
    ogp = exp(oglo)./(1+exp(oglo));
    
    % ------end of your occupancy grid mapping algorithm-------

    % draw the map
    clf;
    pcolor(ogp);
    colormap(1-gray);
    shading('flat');
    axis equal;
    axis off;
    
    % draw the robot
    hold on;
    x = (x_interp(i)-ogxmin)/ogres;
    y = (y_interp(i)-ogymin)/ogres;
    th = theta_interp(i);
    r = 0.15/ogres;
    set(rectangle( 'Position', [x-r y-r 2*r 2*r], 'Curvature', [1 1]),'LineWidth',2,'FaceColor',[0.35 0.35 0.75]);
    set(plot([x x+r*cos(th)]', [y y+r*sin(th)]', 'k-'),'LineWidth',2);
    
    % save the video frame
    M = getframe;
    writeVideo(vid,M);
    
    pause(0.1);
    
end

close(vid);
print -dpng ass3_q1.png

save occmap.mat ogres ogxmin ogxmax ogymin ogymax ognx ogny oglo ogp;

