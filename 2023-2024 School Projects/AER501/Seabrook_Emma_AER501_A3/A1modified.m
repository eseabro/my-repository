function [sig] = A1modified(areas)
%%      Input Variables:
%       coords [array] contains x and y coords of each node
%       connec [matrix] connectivity matrix of nodes
%       young  [array] contains young's modulus for each node
%       areas  [array] contains cross-sectional area of each node
%       P      [array] contains the node-wise forces
%       bounds [array] node-dof-wise boundary conditions. 0 indicates that the bound is stationary. 
%                      1 indicates that the node is free to move in that direction. 
%%      Outputs:
%       K [matrix] - stiffness of each element
%       D [array] - displacements of each element
%       sig [array] - Stresses for each element
%       str [array] - Strains for each element 
%%
young = 70*10^9 *ones(1,10);
P = [0;0; 0;0; 0;0; 0;-100; 0;-100; 0;0];
coords = [0,1;1,1;2,1;2,0;1,0;0,0];
connec = [1,2;2,3;3,4;1,5;2,6;2,4;3,5;4,5;5,6;2,5];
bounds = true&[0;0; 1;1; 1;1; 1;1; 1;1; 0;0];

s_node = size(coords);
s_elem = size(connec);
n_elem = s_elem(1);
n_node = s_node(1);
nDOF = 2*n_node;

K = A1assembly(coords, connec, young, areas, nDOF, n_elem, n_node); % Create Global Stiffness matrix
d = A1solve_k(K, P, bounds); %incorporate BCs and solve for displacements
j = 1;
for i=1:length(bounds)
    if bounds(i)==0
        D(i, 1) = 0;
    else
        D(i, 1) = d(j);
        j =  j+1;
    end
end
sig = A1postprocess(coords, connec, young, areas, n_elem, D); %calculate stresses and strains

end