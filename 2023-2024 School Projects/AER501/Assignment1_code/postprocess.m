function [stress, strains] = postprocess(coords, connec, young, areas, n_elem, d)
    for i=1:n_elem
        elem_coords = [coords(connec(i,1), :); coords(connec(i,2), :)];
        dx = elem_coords(2,1)-elem_coords(1,1);
        dy = elem_coords(2,2)-elem_coords(1,2);
        L = sqrt(dx^2 + dy^2);

        n1 = [connec(i,1)*2-1: connec(i,1)*2, connec(i,2)*2-1: connec(i,2)*2];
        stress(1,i) = (young(i)/L^2)*[-dx -dy dx dy]*d(n1);
        strains(1,i) = (young(i)*areas(i)/L^2)*[-dx -dy dx dy]*d(n1);
    end
end