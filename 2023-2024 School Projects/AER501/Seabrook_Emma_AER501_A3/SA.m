function [xopt,fopt,f_best] = SA(x0, lb, ub, epsilon, maxiter, Tstart, c, f_opt, constraint, rho)

%% Inputs:
% x0        - initial guess
% lb        - lower bound
% up        - upper bound
% epsilon   - step size for magnitude of perturbations
% maxiter   - maximum number of iterations
% Tstart    - starting temperature
% c         - cooling schedule parameter
% f_opt     - the function call to optimize
% constraint- the constraint function to use
% pen       - the penalty parameter to use

%% Outputs 
% xopt      - the x value that corresponds to the optimized function
% fopt      - the optimized function value
% f_best    - array containing the best value at each iteration


% Set up initial calculation

if isempty(constraint) == 1
    rho = 0;
    psi_x = 0;
else
    [g1_x, g2_x, ~] = constraint(x0);

    for j = 1:length(g1_x)
        if g1_x(j) <= 0 
            g1_x(j) = 0;
        end
        if g2_x(j) <= 0 
            g2_x(j) = 0;
        end
    end
    g_x = max(g1_x, g2_x);
    psi_x = sum(max(0,g_x).^2);
end
f_x = f_opt(x0) + rho*psi_x;
T = Tstart;
i = 2;
f_best = [f_x];

% Define lower and upper bounds to use in move.m
lb_move = zeros(1,length(x0));
ub_move = ones(1,length(x0));

while i < maxiter
    % Calculate x prime
    x_curr_norm = (x_curr - lb) ./ (ub-lb);
    perturb = move(x_curr_norm, lb_move, ub_move, epsilon);
    x_prime = perturb.*(ub-lb)+lb;


    if ~isempty(constraint)
        % Calculate f(x prime)
        [g1_x, g2_x, ~] = constraint(x_prime);

        for j = 1:length(g1_x)
            if g1_x(j) <= 0 
                g1_x(j) = 0;
            end
            if g2_x(j) <= 0 
                g2_x(j) = 0;
            end
        end
        g_x = max(g1_x, g2_x);
        psi_x = sum(max(0,g_x).^2);
    end
    f_x_p = f_opt(x_prime) + rho*psi_x;

    % Determine whether to accept or reject the move
    del_E = f_x - f_x_p;
    if del_E > 0
        x_curr = x_prime;
        f_x = f_x_p;
    else
        prob = exp(del_E/T);
        if prob > 0.9
            x_curr = x_prime;
            f_x = f_x_p;
        end
    end

    % Update Parameters
    T = schedule(T,c,i);
    f_best(i, :) = min(f_x, f_best(i-1));


    i = i+1;
end

xopt = x_curr;
fopt = f_x;

end