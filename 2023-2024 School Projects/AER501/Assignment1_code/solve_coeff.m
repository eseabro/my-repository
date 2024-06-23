function [c1, c2] = solve_coeff(ode_g, ode_m, co_pts, n, sig)
    % Initialize arrays and matrices
    x = co_pts;
    b = zeros(n,1);
    A_g = zeros(n,n);
    A_m = zeros(n,n);


    for i=2:n-1 % Iterate over x values
        for j=1:n % Iterate over RBF centres
            A_g(i,j) = ode_g(co_pts(i), co_pts(j));
            A_m(i,j) = ode_m(co_pts(i), co_pts(j));
        end
        % Set exact value
        b(i,1) = co_pts(i);
    end

    % Apply boundary conditions
    A_g(1, :) = exp(-(x(1)-co_pts).^2/sig);
    A_g(n, :) = exp(-(x(n)-co_pts).^2/sig);
    A_m(1, :) = sqrt(1+(x(1)-co_pts).^2/sig);
    A_m(n, :) = sqrt(1+(x(n)-co_pts).^2/sig);

    % Solve for coefficients
    c1 = A_g\b;
    c2 = A_m\b;

end