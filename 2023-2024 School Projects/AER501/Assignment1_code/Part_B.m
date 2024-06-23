%% Part 1: Test approximation
clear;
i0 = 0;
i1 = 1;
n = 90;

% Define exact solution
t_sol = @(x) 0.8509*sinh(x)-x;

h = 1/(n-1);
sig = 2.2*h;
x = linspace(i0,i1,n);
c = x;

% Initialize function calls
[ode_g, ode_m, phi_g, phi_m] = f_calls(sig);
% Solve for the coefficients
[c1, c2] = solve_coeff(ode_g, ode_m, x, n, sig);

% Initialize matrix of RBF approximations for each x and c
for i=1:n
    L_g(i, :) = phi_g(x, c(i));
    L_m(i, :) = phi_m(x, c(i));
end

% multiply to get u_hat = sum(c_i*phi_i)
u_hat_g = L_g*c1;
u_hat_m = L_m*c2;

% Plot to compare results
figure(1)
plot(x, u_hat_g);
hold on;
plot(x, u_hat_m);
hold on;
plot(x, t_sol(x));
title("Comparing Three Methods");
legend('Gaussian', 'Multiquadratic', 'True');
hold off;
%% Part 2: Determine effect of h on approximation error
clear;
i0 = 0;
i1 = 1;
N = 500;

% Initialize Error arrays
err_g = zeros(N,1);
err_m = zeros(N,1);

% Define exact solution
t_sol = @(x) 0.8509*sinh(x)-x;

% Iterate for different values of n 
for n=1:N
    h = 1/(n-1);
    sig = 2.2*h;
    co_pts = linspace(i0,i1,n);
    c = co_pts;
    
    % Define function calls
    [ode_g, ode_m, phi_g, phi_m] = f_calls(sig);
    % Solve for coefficients
    [c1, c2] = solve_coeff(ode_g, ode_m, co_pts, n, sig);
    % Initialize approximation matrices
    L_g = zeros(n);
    L_m = zeros(n);


    % fill matrices for phi_i(x_j)
    for i=1:n
        L_g(i, :) = phi_g(c, co_pts(i));
        L_m(i, :) = phi_m(c, co_pts(i));
    end

    % multiply to get u_hat = sum(c_i*phi_i)
    u_hat_g = L_g*c1;
    u_hat_m = L_m*c2;
    
    % Calculate norm error
    err_g(n,1) = calc_error(u_hat_g', t_sol(co_pts));
    err_m(n,1) = calc_error(u_hat_m', t_sol(co_pts));
end

% Plot results
figure(2)
n_vec = linspace(1,N,N);
loglog(n_vec, err_g);
hold on;
loglog(n_vec, err_m);
title("L^2 convergence")
legend("Gaussian RBF", "Multiquadric RBF");
xlabel("1/h")
ylabel("L^2 Error")

%% Part 3: Determine effect of sigma on approximation error

clear;
n = 7;
i0 = 0;
i1 = 1;
co_pts = linspace(i0,i1,n);

% Define exact solution
t_sol = @(x) 0.8509*sinh(x)-x;
n_sig = 1000;
sig = linspace(0, 500, n_sig);
L_g = zeros(n);
L_m = zeros(n);

% Iterate for different values of sigma 
for s=1:n_sig
    % Define functions and solve
    [ode_g, ode_m, phi_g, phi_m] = f_calls(sig(s));
    [c1, c2] = solve_coeff(ode_g, ode_m, co_pts, n, sig(s));

    for i=1:n
        L_g(i, :) = phi_g(co_pts, co_pts(i));
        L_m(i, :) = phi_m(co_pts, co_pts(i));
    end
    % Multiply to get u_hat
    u_hat_g = L_g*c1;
    u_hat_m = L_m*c2;
    
    err_g(s) = calc_error(u_hat_g', t_sol(co_pts));
    err_m(s) = calc_error(u_hat_m', t_sol(co_pts));
end

% Plot Results
figure(3)
loglog(sig, err_g);
hold on;
loglog(sig, err_m);
title("L^2 convergence")
legend("Gaussian RBF", "Multiquadric RBF");
xlabel("\sigma")
ylabel("L^2 Error")
