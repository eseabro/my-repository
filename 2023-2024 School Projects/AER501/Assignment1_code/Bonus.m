clear; close all;
N = 20; % Number of collocation points
x1 = linspace(0, 1, N);
x2 = linspace(0, 1, N);

h = 1 / (N - 1);
sig = 2.2*h;

% Radial Basis function as a function of the 2-norm.
rbf = @(r) exp(-r.^2/sig);
% Second Derivative of the radial basis function
d2_rbf =  @(r) (2*(2*r^2-sig)/sig^2)*exp(-r^2/sig);
% Exact solution 
exact_sol = @(x_1, x_2) -sin(pi * x_1) .* sin(pi * x_2) / (2 * pi^2);

% Initialize matrices that will be needed
A = zeros(N);
b = zeros(N, 1);
exact = zeros(N);
coeffs = zeros(N);
U = zeros(N);


for i = 1:N % Looping through x1
    for j = 1:N % Looping through x2
        
        xij = [x1(i), x2(j)];

        for k = 1:N % Looping through RBF centres
            z = [x1(i), x2(k)];
            r = sqrt(sum((xij - z).^2/2, 2)); % Calculate norm
            A(j, k) = d2_rbf(r);

        end
        % Setting the values of b = sin(pi*x1)*sin(pi*x2)
        b(j) = sin(pi * x1(i)) * sin(pi * x2(j));

    end

    c_all = [x1(i)*ones(N,1), x2'];

    % Set boundary conditions
    b(1) = 0;
    b(N) = 0;

    % Setting x(1) and x(N) vectors
    xi_1 = [x1(i), x2(1)];
    xi_N = [x1(i), x2(N)];
    
    % Obtain the 2-norm between the vectors and the centres
    r_1 = sqrt(sum((xi_1-c_all).^2/2, 2));
    r_N = sqrt(sum((xi_N-c_all).^2/2, 2));
    
    % Setting the boundary conditions in the A matrix
    A(1, :) = exp(-(r_1).^2/sig);
    A(N, :) = exp(-(r_N).^2/sig);

    % Solving
    coeffs(i, :) = A \ b;

end


% Iterate over points again to get u = c*phi
for i=1:N

    z = [x1(i)*ones(N,1), x2']; % centres

    for j=1:N
        x_i = [x1(i), x2(j)];

        r = sqrt(sum((x_i-z).^2/2, 2)); % norm between point and centres
        L = rbf(r);
        U(i, j) = sum(L.*coeffs(i, :)');

        % Set up the exact solution for comparison
        exact(i,j) = exact_sol(x1(i), x2(j)); 
    end
    
end

% Calculate L^2 norm of the error
disp("L^2 norm of the error: ")
sqrt(sum((exact-U).^2, 'all'))

% Plot the numerical solution 
figure;
surf(x1, x2, U);
title('Numerical Solution');
xlabel('x1');
ylabel('x2');
zlabel('u(x1, x2)');

% Plot the exact solution
figure;
surf(x1, x2, exact);
title('Exact Solution');
xlabel('x1');
ylabel('x2');
zlabel('u(x1, x2)');


