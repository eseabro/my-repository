function mat = elementmatrix(coords, E, A)
    k = zeros(4, 4);
    dx = coords(2,1)-coords(1,1);
    dy = coords(2,2)-coords(1,2);
    L = sqrt(dx^2 + dy^2);

    node = [dx*dx, dx*dy; dx*dy, dy*dy];
    k = [node, -node; -node, node];
    mat = (E*A/(L^3))*k;
end
