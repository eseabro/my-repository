function [K, D, sig, str] = A1modified(coords, connec, young, areas, P, bounds)
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
[sig, str] = A1postprocess(coords, connec, young, areas, n_elem, D); %calculate stresses and strains

end