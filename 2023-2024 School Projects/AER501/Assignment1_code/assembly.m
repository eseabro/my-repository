function K = assembly(coords, connec, young, areas, nDOF, n_elem, n_node)
    K = zeros(nDOF, nDOF);
    connec_dof = zeros(n_elem, 4);

    dof_elem = round((nDOF/n_node)*2);

    for i=1:n_elem %element wise
        elem_coords = [coords(connec(i,1), :); coords(connec(i,2), :)];
        Kelement = elementmatrix(elem_coords, young(i), areas(i)); % element matrix calculation    
        connec_dof(i,:) = [(connec(i,1)*2-1):connec(i,1)*2, connec(i,2)*2-1:connec(i,2)*2];
        
        for j=1:dof_elem % 
            for k=1:dof_elem % 
                ip = connec_dof(i,j);
                jp = connec_dof(i,k);
                K(ip,jp) = K(ip,jp) + Kelement(j, k);
                
            end
        end
    end
end