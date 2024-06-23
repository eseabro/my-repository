clear all;
a0 = 1;
b0 = 3;
tol =  10^-4;
x0 = 2; 
tol2 = 10^-12;
% known root is at 2.0946. Function performs correctly
[a,b] = my_bisection(@fun,a0,b0,tol);
x = my_newton(@fun,x0,tol2);
%%part 2c
[a_b,b_b] = my_bisection(@nonlinear_bench,a0,b0,tol)
x_b = my_newton(@nonlinear_bench,x0,tol2)

x_i = my_newton(@nonlinear_bench, i, tol2)
x_i2 = my_newton(@nonlinear_bench, -i, tol2)

x0 = [0;1.0];
[x_opt, fmin] = my_newton_opt(@my_fun, x0,tol2)

% Find values for convergence table
diff = ones([2,size(x_opt,2)]) - x_opt;
disp(vecnorm(diff))
diff2=(vecnorm(diff(:,2:7))./vecnorm(diff(:,1:6)));
to = sqrt(vecnorm(diff))
disp(to)

x = linspace(-1.25,1.25,1000)';
y = linspace(-0.75, 1.75,1000)';
[X, Y] = meshgrid(x,y);

for i = 1:length(x)
    for j = 1:length(y)
        rosenbrock(i,j) = my_fun([X(i,j),Y(i,j)]);
    end
end

contour(X, Y, rosenbrock,100)
hold on;
h = plot(x_opt(1,:),x_opt(2,:), 'o-r');
xlabel('x')
ylabel('y')


function [f,df] = fun(x)
    f = x^3 - 2*x - 5; 
    df = 3*x^2 - 2;
end

function [a,b] = my_bisection(fun,a0,b0,tol)
    TOL = tol + 1;
    L = a0;
    R = b0;
    while TOL > tol
        c = (L+R)/2;
        [f_c, m] = fun(c);
        if f_c < 0 
            L = c;
            TOL = abs(R - L);
        elseif f_c > 0
            R = c;
            TOL = abs(R - L);
        else
            TOL = 0;
        end
    end
    a = L;
    b = R;
end

function x = my_newton(fun,x0,tol)
    TOL = tol + 1;
    x = x0;
    while TOL>tol
        [f, d_f] = fun(x);
        x = x - f/d_f;
        TOL = norm(f);
    end
end



%% optimization functions:
function [f, grad, hess] = my_fun(z)
    x = z(1);
    y = z(2);
    f = (1-x)^2 + 10*(y-x^2)^2;
    grad = [-2*(1-x) - 40*x*(y-x^2); ...
            20*(y-x^2)];
    hess = [2-40*(y-x^2)+80*x^2, -40*x; -40*x, 20];
end


function [x, fmin] = my_newton_opt(fun, x0,tol)
    x(:,1) = x0;
    dx = tol+1;
    i = 2;
    while norm(dx) > tol
        [f, grad, hess] = fun(x(:,i-1));
        dx = (hess)\grad;
        x(:,i) = x(:,i-1) - dx;
        i = i + 1;
    end
    fmin = f;
end





