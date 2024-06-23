function u = modalfrfanalysis(omega, PHI, LAM, f, m)
%% Inputs:
% % omega     - Frequency value
% % PHI       - Eigenvectors of K and M
% % LAM       - Vector of Eigenmodes
% % f         - Excitation vector
% % m         - Number of modes to use for analysis
%% Outputs
% % u         - Displacement 

    I = eye(length(PHI));
    omega = omega*2*pi;
    j = sqrt(-1);
    gamm1 = 0;
    gamm2 = 10;
    
    b = PHI(:, 1:m)'*f;
    A = LAM(1:m) - omega^2*I(1:m, 1:m) + j*omega*(gamm1*LAM(1:m)+gamm2*I(1:m, 1:m)');
    q = b./diag(A);
    u = PHI(:,1:m)*q;

end