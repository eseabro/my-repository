function [ode_g, ode_m, phi_g, phi_m] = f_calls(s)
    % Radial Basis Functions
    phi_g = @(x,z) exp(-((x-z).^2)./s);
    phi_m = @(x,z) sqrt(1+(x-z).^2./s);
    
    % Second Derivative of RBFs
    phi_g_p = @(x,z)  -(2.*((s-2.*(x-z).^2))/(s^2)).*exp(-((x-z).^2)./s);
    phi_g_m = @(x,z)  sqrt(s)./((s+(x-z).^2).*sqrt(s+(x-z).^2));
    
    % Function to use in computation of A
    ode_g = @(x,z) phi_g_p(x,z) - phi_g(x,z);
    ode_m = @(x,z) phi_g_m(x,z) - phi_m(x,z);


end