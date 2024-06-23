% ======
% ROB521_assignment1.m
% ======
%
% This assignment will introduce you to the idea of motion planning for  
% holonomic robots that can move in any direction and change direction of 
% motion instantaneously.  Although unrealistic, it can work quite well for
% complex large scale planning.  You will generate mazes to plan through 
% and employ the PRM algorithm presented in lecture as well as any 
% variations you can invent in the later sections.
% 
% There are three questions to complete (5 marks each):
%
%    Question 1: implement the PRM algorithm to construct a graph
%    connecting start to finish nodes.
%    Question 2: find the shortest path over the graph by implementing the
%    Dijkstra's or A* algorithm.
%    Question 3: identify sampling, connection or collision checking 
%    strategies that can reduce runtime for mazes.
%
% Fill in the required sections of this script with your code, run it to
% generate the requested plots, then paste the plots into a short report
% that includes a few comments about what you've observed.  Append your
% version of this script to the report.  Hand in the report as a PDF file.
%
% requires: basic Matlab, 
%
% S L Waslander, January 2022
%
clear; close all; %clc;

% set random seed for repeatability if desired
% rng(1);

% ==========================
% Maze Generation
% ==========================
%
% The maze function returns a map object with all of the edges in the maze.
% Each row of the map structure draws a single line of the maze.  The
% function returns the lines with coordinates [x1 y1 x2 y2].
% Bottom left corner of maze is [0.5 0.5], 
% Top right corner is [col+0.5 row+0.5]
%



row = 5; % Maze rows
col = 7; % Maze columns
map = maze(row,col); % Creates the maze
start = [0.5, 1.0]; % Start at the bottom left
finish = [col+0.5, row]; % Finish at the top right

origin = [0.5, 0.5];
max = [col+0.5, row+0.5];

h = figure(1);clf; hold on;
plot(start(1), start(2),'go')
plot(finish(1), finish(2),'rx')
show_maze(map,row,col,h); % Draws the maze
drawnow;

% ======================================================
% Question 1: construct a PRM connecting start and finish
% ======================================================
%
% Using 500 samples, construct a PRM graph whose milestones stay at least 
% 0.1 units away from all walls, using the MinDist2Edges function provided for 
% collision detection.  Use a nearest neighbour connection strategy and the 
% CheckCollision function provided for collision checking, and find an 
% appropriate number of connections to ensure a connection from  start to 
% finish with high probability.


% variables to store PRM components
nS = 5*row*col; % number of samples to try for milestone creation
edges = [];  % each row should be an edge of the form [x1 y1 x2 y2]

disp("Time to create PRM graph")
tic;
% ------insert your PRM generation code here-------

x_vals = linspace(origin(1), max(1), col*5);
y_vals = linspace(origin(2), max(2), row*5);


sample_x = datasample(x_vals, nS);
sample_y = datasample(y_vals, nS);

samples_a = [start(1), sample_x, finish(1); start(2), sample_y, finish(2)];
samples = unique(samples_a.','rows').';
md = MinDist2Edges(samples', map);

samples = samples(:,md>0.1);

NN = 20; % Number of nearest neighbours to connect


for m=1:length(samples)
    s_curr = samples(:,m);
    s_wo_pt = samples;
    s_wo_pt(:, m) = [];

    sample_dists = ((s_wo_pt(1,:) - s_curr(1)).^2 + (s_wo_pt(2,:) - s_curr(2)).^2).^(1/2);
    [~, I] = mink(sample_dists, NN);
    
    for i=1:NN
        % Check if path to nearest neighbours are in collision
        [inCollision, edge] = CheckCollision(s_curr', s_wo_pt(:,I(i))', map);
        if ~inCollision && ((size(edges,1) == 0) || (sum(ismember(edges, [s_wo_pt(:,I(i))', s_curr'], 'rows')) == 0))
            edges(size(edges,1)+1, :) = [s_curr', s_wo_pt(:,I(i))'];
        end

    end
end

milestones = samples'; % each row is a point [x y] in feasible space
% ------end of your PRM generation code -------

figure(1);
plot(milestones(:,1),milestones(:,2),'m.');
if (~isempty(edges))
    line(edges(:,1:2:3)', edges(:,2:2:4)','Color','magenta') % line uses [x1 x2 y1 y2]
end
str = sprintf('Q1 - %d X %d Maze PRM', row, col);
title(str);
drawnow;

print -dpng assignment1_q1_2.png


% =================================================================
% Question 2: Find the shortest path over the PRM graph
% =================================================================
%
% Using an optimal graph search method (Dijkstra's or A*) , find the 
% shortest path across the graph generated.  Please code your own 
% implementation instead of using any built in functions.



% Variable to store shortest path
spath = []; % shortest path, stored as a milestone row index sequence


% ------insert your shortest path finding algorithm here-------


% Dijkstras
Q = [];
Q(1, :) = [start, 0, 0, 0]; % start, C2C
unvisited = edges;
dead_nodes = [];

q=0;
while ~isempty(Q)
    q = q + 1; 
    x = Q(1,:); % Get first index
    Q(1,:) = []; % delete item at first index (kill node)
    dead_nodes(q,:) = x; % [curr, prev, c2c]

    if isequal(x(1:2), finish)
        y = x(1:4); % y = curr, prev, c2c
        while ~isequal(y(size(y, 1), 1:2), start)
            connected_dead = dead_nodes(all(dead_nodes(:,1:2) == y(size(y, 1), 1:2), 2), 3:4);
            spath(length(spath)+1) = find(all(milestones == y(size(y,1), 1:2), 2));
            y(size(y, 1) + 1, :) = [connected_dead, y(size(y,1), 1:2)]; % Update y
        end
        spath(length(spath)+1) = find(all(milestones == y(size(y,1), 1:2), 2));

        spath = flip(spath,1);
        break
    end

    L = all(unvisited(:,1:2) == x(1:2), 2);
    connections = unvisited(L,:); % [start, stop]

    for i=1:size(connections,1)
        c2c = x(5) + ((connections(i, 1)-connections(i, 3))^2 + (connections(i, 2)-connections(i, 4))^2)^(1/2);
        if (isempty(dead_nodes)) || ~sum(all(dead_nodes(:,1:2) == connections(i,3:4),2))
            in_q = find(all(Q(:, 1:2) == connections(i,3:4),2));
            if ~isempty(in_q) && (Q(in_q,5)> c2c)
               Q(in_q,5) = c2c;
            elseif (isempty(in_q))
               Q(size(Q, 1)+1,:) = [connections(i,3:4), x(1:2), c2c];
            end
        end
    end

    L = all(unvisited(:,3:4) == x(1:2), 2);
    connections = unvisited(L,:); % [start, stop]

    for i=1:size(connections,1)
        c2c = x(5) + ((connections(i, 1)-connections(i, 3))^2 + (connections(i, 2)-connections(i, 4))^2)^(1/2);
        if (isempty(dead_nodes)) || ~sum(all(dead_nodes(:,1:2) == connections(i,1:2),2))
            in_q = find(all(Q(:, 1:2) == connections(i,1:2),2));
            if ~isempty(in_q) && (Q(in_q,5)> c2c)
               Q(in_q,5) = c2c;
            elseif (isempty(in_q))
               Q(size(Q, 1)+1,:) = [connections(i,1:2), x(1:2), c2c];
            end
        end
    end

    Q = sortrows(Q, 5);
end

% ------end of shortest path finding algorithm------- 
dt2 = toc;
disp("Total Sec1 time:")

% plot the shortest path
figure(1);
for i=1:length(spath)-1
    plot(milestones(spath(i:i+1),1),milestones(spath(i:i+1),2), 'go-', 'LineWidth',3);
end
str = sprintf('Q3 - %d X %d Maze Shortest Path: %f', row, col, dt2);
title(str);
drawnow;

print -dpng assingment1_q2_2.png


%% ================================================================
% Question 3: find a faster way
% ================================================================
%
% Modify your milestone generation, edge connection, collision detection 
% and/or shortest path methods to reduce runtime.  What is the largest maze 
% for which you can find a shortest path from start to goal in under 20 
% seconds on your computer? (Anything larger than 40x40 will suffice for 
% full marks)
clear; clc; close all;

row = 60;
col = 60;
map = maze(row,col);

origin = [0.5, 0.5];
max_e = [col+0.5, row+0.5];
nS = 8*row*col;

start = [0.5, 1.0];
finish = [col+0.5, row];

h = figure(2);clf; hold on;
plot(start(1), start(2),'go')
plot(finish(1), finish(2),'rx')
show_maze(map,row,col,h); % Draws the maze
drawnow;

fprintf("Attempting large %d X %d maze... \n", row, col);
tic;        
% ------insert your optimized algorithm here------
x_vals = linspace(1, col, col);
y_vals = linspace(1, row, row);

sample_x = datasample(x_vals, nS);
sample_y = datasample(y_vals, nS);

samples_a = [start(1), sample_x, finish(1); start(2), sample_y, finish(2)];
milestones = unique(samples_a.','rows');
% 
% md = MinDist2Edges_vec(milestones, map);
% 
% milestones = milestones(md>0.1,:);
edges = zeros(size(milestones, 1), 4);

NN = 4; % Number of nearest neighbours to connect
edg = 1;


for m=1:size(milestones,1)
    s_curr = milestones(m,:);
    s_wo_pt = milestones;
    s_wo_pt(m, :) = [];

    sample_dists = ((s_wo_pt(:, 1) - s_curr(1)).^2 + (s_wo_pt(:, 2) - s_curr(2)).^2).^(1/2);
    [~, I] = mink(sample_dists, NN);
    
    for i=1:NN
        % Check if path to nearest neighbours are in collision
        [inCollision, edge] = CheckCollision2(s_curr, s_wo_pt(I(i),:), map);
        if ~inCollision && ~any(all(edges == [s_wo_pt(I(i), :), s_curr], 2))
            edges(edg, :) = [s_curr, s_wo_pt(I(i), :)];
            edg = edg + 1;
        end

    end
end

figure(2); hold on;
plot(milestones(:,1),milestones(:,2),'m.');
if (~isempty(edges))
    line(edges(:,1:2:3)', edges(:,2:2:4)','Color','magenta')
end


spath = []; % shortest path, stored as a milestone row index sequence
Q = [];
Q(1, :) = [start, [0, 0], 0]; % start, C2C
unvisited = edges;
dead_nodes = zeros(round(size(unvisited,1)/4), 5);

q=0;
while ~isempty(Q)
    q = q + 1; 
    x = Q(1,:); % Get first index
    Q(1,:) = []; % delete item at first index (kill node)
    dead_nodes(q,:) = x; % [curr, prev, c2c]

    if isequal(x(1:2), finish)
        y = x(1:4); % y = curr, prev, c2c
        while ~isequal(y(size(y, 1), 1:2), start)
            connected_dead = dead_nodes(all(dead_nodes(:,1:2) == y(size(y, 1), 1:2), 2), 3:4);
            spath(length(spath)+1) = find(all(milestones == y(size(y,1), 1:2), 2));
            y(size(y, 1) + 1, :) = [connected_dead, y(size(y,1), 1:2)]; % Update y
        end
        spath(length(spath)+1) = find(all(milestones == y(size(y,1), 1:2), 2));

        spath = flip(spath,1);
        break
    end

    L = all(unvisited(:,1:2) == x(1:2), 2);
    connections = unvisited(L,:); % [start, stop]

    for i=1:size(connections,1)
        c2c = x(5) + ((connections(i, 1)-connections(i, 3))^2 + (connections(i, 2)-connections(i, 4))^2)^(1/2);
        if (isempty(dead_nodes)) || ~sum(all(dead_nodes(:,1:2) == connections(i,3:4),2))
            in_q = find(all(Q(:, 1:2) == connections(i,3:4),2));
            if ~isempty(in_q) && (Q(in_q,5)> c2c)
               Q(in_q,5) = c2c;
            elseif (isempty(in_q))
               Q(size(Q, 1)+1,:) = [connections(i,3:4), x(1:2), c2c];
            end
        end
    end

    L = all(unvisited(:,3:4) == x(1:2), 2);
    connections = unvisited(L,:); % [start, stop]

    for i=1:size(connections,1)
        c2c = x(5) + ((connections(i, 1)-connections(i, 3))^2 + (connections(i, 2)-connections(i, 4))^2)^(1/2);
        if (isempty(dead_nodes)) || ~sum(all(dead_nodes(:,1:2) == connections(i,1:2),2))
            in_q = find(all(Q(:, 1:2) == connections(i,1:2),2));
            if ~isempty(in_q) && (Q(in_q,5)> c2c)
               Q(in_q,5) = c2c;
            elseif (isempty(in_q))
               Q(size(Q, 1)+1,:) = [connections(i,1:2), x(1:2), c2c];
            end
        end
    end

    Q = sortrows(Q, 5);
end



% ------end of your optimized algorithm-------
dt = toc;
disp("Elapsed Time is: ");
disp(dt);

figure(2); hold on;
% plot(milestones(:,1),milestones(:,2),'m.');
% if (~isempty(edges))
%     line(edges(:,1:2:3)', edges(:,2:2:4)','Color','magenta')
% end
if (~isempty(spath))
    for i=1:length(spath)-1
        plot(milestones(spath(i:i+1),1),milestones(spath(i:i+1),2), 'go-', 'LineWidth',3);
    end
end
str = sprintf('Q3 - %d X %d Maze solved in %f seconds', row, col, dt);
title(str);

print -dpng assignment1_q3_3.png

