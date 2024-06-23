function u_0 = directfrfanalysis(K, M, C, omega, f)
%% Inputs
% % K       - Stiffness matrix
% % M       - Mass Matrix
% % C       - Damping Matrix
% % omega   - Excitation frequency
% % f       - Excitation forces by node
%% Outputs
% % u_0     - Displacements at t=0

    omega = omega*2*pi;
    j = sqrt(-1);
    DSM = K - (omega.^2).*M + j*omega*C;
    u_0 = DSM\f;

end