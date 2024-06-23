function [K, M] = assembly(X, Y, connec, EA, EI, RHO, nDOF, n_elem)
    K = zeros(nDOF, nDOF);
    M = zeros(nDOF, nDOF);

    dof_elem = 6;
    connec_dof = zeros(n_elem, dof_elem);

    for i=1:n_elem %element wise
        X1 = X(connec(i,1));
        Y1 = Y(connec(i,1));
        X2 = X(connec(i,2));
        Y2 = Y(connec(i,2));
        Kelement = ElementStiffMat(EA, EI, X1, Y1, X2, Y2); % element matrix calculation 
        Melement = ElementMassMat(RHO, X1, Y1, X2, Y2); % element matrix calculation 

        connec_dof(i,:) = [connec(i,1)*3-2:connec(i,1)*3, connec(i,2)*3-2:connec(i,2)*3];
        
        for j=1:dof_elem % 
            for k=1:dof_elem % 
                ip = connec_dof(i,j);
                jp = connec_dof(i,k);
                K(ip,jp) = K(ip,jp) + Kelement(j, k);
                M(ip,jp) = M(ip,jp) + Melement(j,k);
                
            end
        end
    end
end