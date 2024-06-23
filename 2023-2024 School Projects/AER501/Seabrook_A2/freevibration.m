function [f_i, PHI] = freevibration(K, M)
%% Inputs
% % K       - Stiffness Matrix
% % M       - Mass Matrix
%% Outputs
% % f_i     - Eigenvalues of K,M
% % PHI     - Orthonormalized Eigenvectors of K, M

    [phi, lam] = eig(K,M); % K*phi = M*phi*lam 
    f_i = diag(lam);
    for i=1:length(phi)
        PHI(:,i) = 1/sqrt(phi(:,i)'*M*phi(:,i))*phi(:,i);
    end
end