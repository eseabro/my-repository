function u = quasi_static(K, f, PHI, LAM, u_modal, m)
%% Inputs
% % K         - Stiffness matrix
% % f         - Excitation forces by node
% % PHI       - Eigenvectors of K and M
% % LAM       - Vector of Eigenmodes
% % u_modal   - Modal approximation 
% % m         - Number of modes to use for analysis
%% Outputs
% % u         - Displacement response

    del_u = inv(K)*f - PHI(:, 1:m)*inv(diag(LAM(1:m)))*PHI(:, 1:m)'*f;

    u = u_modal + del_u;

end