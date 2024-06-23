%% Test Case 1 from assignment:
areas = [0.0001, 0.0001, 0.0001];
young = [70*10^9, 70*10^9, 70*10^9];
forces = [0;0;0;0;0;0;100;0];
nodal_coords = [0,1; 1,1; 2,1; 1,0];
connec = [1,4;2,4;3,4];
bcs = true&[0;0;0;0;0;0;1;1];

[K, d, sig, str] = maindriver(nodal_coords, connec, young, areas, forces, bcs);

disp("Global Stiffness matrix:")
disp(K)
disp("Displacements:")
disp(d)
disp("Stresses")
disp(sig)
disp("Strains")
disp(str)

%% Test Case 2 from assignment:
clear;
areas = 0.0001*ones(1,10);
young = 70*10^9 *ones(1,10);
forces = [0;0; 0;0; 0;0; 0;-100; 0;-100; 0;0];
nodal_coords = [0,1;1,1;2,1;2,0;1,0;0,0];
connec = [1,2;2,3;3,4;1,5;2,6;2,4;3,5;4,5;5,6;2,5];
bcs = true&[0;0; 1;1; 1;1; 1;1; 1;1; 0;0];
[K, d, sig, str] = maindriver(nodal_coords, connec, young, areas, forces, bcs);

disp("Global Stiffness matrix:")
disp(K)
disp("Displacements:")
disp(d)
disp("Stresses")
disp(sig)
disp("Strains")
disp(str)
