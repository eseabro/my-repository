function maindriver()
    % Create array to store possible c values
    c = linspace(0.5, 1, 50);

    % Set up initial conditions
    epsilon = 0.3;
    maxiter = 5000;
    lb = [0,0];
    ub = [pi, pi];
    x0 = [0, 0];
    Tstart = 1000;

    % iterate for different values of c
    for j = 1:50
        xopt  = [];
        fopt  = [];
        f_b = [];

        % iterate 200x to get average
        for k = 1:200

            [xopt(k,:), fopt(k,:), f_best] = SA(x0, lb, ub, epsilon, maxiter, Tstart, c(j), @objfcn, [], 0.5);
            try
                f_b(k) = find(round(f_best,4) <= -1.801, 1);
            catch
                f_b(k) = 5000;
            end
        end
        % Get average best value and average 
        fopt_c(j) = mean(fopt);
        best(j) = mean(f_b);
    end

    % Plot results
    figure()
    plot(c, fopt_c);
    xlabel("Cooling Schedule Parameter c")
    ylabel("Average Converged f(x)")
    title("Effect of Cooling Parameter on Result")

    figure()
    plot(c, best);
    xlabel("Cooling Schedule Parameter c")
    ylabel("Number of Iterations")
    title("Effect of Cooling Parameter on No. of Iterations to reach Correct Solution")


    % Recalculate results with best 
    [xopt, fopt, f_best] = SA(x0, lb, ub, epsilon, maxiter, Tstart, 0.75, @objfcn, [], 0.5);
    A = [];
    b = [];
    Aeq = [];
    beq = [];
    
    % Compare with fmincon
    [x_bonus, f_val_bonus, exit, opt] = fmincon(@objfcn, x0, A, b, Aeq, beq, lb, ub);


%% Part 3: Ten-bar truss
clear;

% Set initial conditions and bounds
lb = (0.0001e-5)*ones(1,10);
ub = 0.0025*ones(1,10);
epsilon = 0.2;
maxiter = 5000;
Tstart = 1000;

a_0 = 0.0001*ones(1,10); % Let the starting value be the value used in A1

c_top = 0.75;
sigma_max_c = -30e6; 
sigma_max_t = 75e6; 

A = [];
b = [];
Aeq = [];
beq = [];

% Lengths of each element
lens = [1, 1, 1, sqrt(2), sqrt(2), sqrt(2), sqrt(2), 1, 1, 1];

% Define functions to optimize and constraint functions
mass_opt = @(areas) sum(2.7.*areas.*lens);
ineq_f = @(x) deal([(A1modified(x) - sigma_max_t); (sigma_max_c - A1modified(x))], []); 
ineq = @(x) deal((A1modified(x) - sigma_max_t), (sigma_max_c - A1modified(x)), []);  

k = 1;
% Iterate over different values of the penalty function
for penalty = [0.01, 0.1, 1, 10, 100, 1000]
    f_best = [];
    % Take the average of 20 runs
    for l = 1:20
        [xopt(l,:), fopt(l,:), f_best(:,l)] = SA(a_0, lb, ub, epsilon, maxiter, Tstart, c_top, mass_opt, ineq, penalty);
    end
    plot(mean(f_best,2))
    pen(k, :) = mean(fopt);
    hold on;
    k = k+1;
end

% Plot comparison between penalty parameter values
xlabel("Iteration no.")
ylabel("Truss Mass")
title("Convergence of SA Based on Penalty Parameter")
legend("\rho = 0.01","\rho = 0.1","\rho = 1","\rho = 10","\rho = 100","\rho = 1000")

[xopt, fopt, f_best] = SA(a_0, lb, ub, epsilon, maxiter, Tstart, c_top, mass_opt, ineq, 1);
[x_bonus, f_val_bonus, exit, opt] = fmincon(mass_opt, a_0, A, b, Aeq, beq, lb, ub, ineq_f);

xplot = xopt*1e6;
xplot_b = x_bonus*1e6;

% Plotting Simulated Thickness plots
figure()
hold on;
plot([0,1],[1,1],'LineWidth',xplot(1), 'Color', 'red')
plot([1,2],[1,1],'LineWidth',xplot(2), 'Color', 'red')
plot([2,2],[1,0],'LineWidth',xplot(3), 'Color', 'red')
plot([0,1],[1,0],'LineWidth',xplot(4), 'Color', 'red')
plot([1,0],[1,0],'LineWidth',xplot(5), 'Color', 'red')
plot([1,2],[1,0],'LineWidth',xplot(6), 'Color', 'red')
plot([2,1],[1,0],'LineWidth',xplot(7), 'Color', 'red')
plot([2,1],[0,0],'LineWidth',xplot(8), 'Color', 'red')
plot([1,0],[0,0],'LineWidth',xplot(9), 'Color', 'red')
plot([1,1],[1,0],'LineWidth',xplot(10), 'Color', 'red')
xlim([-0.5 2.5])
ylim([-0.5, 1.5])
hold off;


% Plotting Simulated Thickness fmincon
figure()
hold on;
plot([0,1],[1,1],'LineWidth',xplot_b(1), 'Color', 'blue')
plot([1,2],[1,1],'LineWidth',xplot_b(2), 'Color', 'blue')
plot([2,2],[1,0],'LineWidth',xplot_b(3), 'Color', 'blue')
plot([0,1],[1,0],'LineWidth',xplot_b(4), 'Color', 'blue')
plot([1,0],[1,0],'LineWidth',xplot_b(5), 'Color', 'blue')
plot([1,2],[1,0],'LineWidth',xplot_b(6), 'Color', 'blue')
plot([2,1],[1,0],'LineWidth',xplot_b(7), 'Color', 'blue')
plot([2,1],[0,0],'LineWidth',xplot_b(8), 'Color', 'blue')
plot([1,0],[0,0],'LineWidth',xplot_b(9), 'Color', 'blue')
plot([1,1],[1,0],'LineWidth',xplot_b(10), 'Color', 'blue')
xlim([-0.5 2.5])
ylim([-0.5, 1.5])
hold off;

end