%% Q2: Forward Euler:
T = 10;
k=1;
for dt = [1 0.5 0.25 0.125 0.0625]
    [tt, uu] = forward_euler(@odefun,T,dt);
    err(k) = norm(cos(tt) - uu);
    plot(tt,uu,'*');
    hold on;
    k = k + 1;
end
plot(tt, cos(tt));
legend('t = 1', 't = 0.5', 't = 0.25');
xlabel('time');
ylabel('u(t)');

%% Q3: C-N:

T = 1;
dt = 0.0001;
[tt,uu] = crank_nicolson(@ode,T,dt);
% since u(t=1) = 2:
E = 2 - uu(end)

% part c:
T = 10;
for dt = [1 0.5 0.25 0.125 0.0625]
    [tt,uu] = crank_nicolson(@odefun,T,dt);
    err = (cos(10) - uu(end))
    figure(2)
    plot(tt,uu);
    hold on;
end
plot(tt, cos(tt));
legend('t = 1', 't = 0.5', 't = 0.25');
xlabel('time');
ylabel('u(t)');
hold off;



%% Q2: 

function [f, dfdu] = odefun(t,u)
    f = 1000*(cos(t) - u) - sin(t);
    dfdu = -1000;
end

function [tt, uu] = forward_euler(odefun,T,dt)
    tt = 0:dt:T;
    uu(1) = 1;
    for i = 2:T/dt+1
        fn = odefun(tt(i-1),uu(i-1));
        uu(i) = uu(i-1) +dt*fn(1);
    end
end






%% Q3: 
function [tt,uu] = crank_nicolson(ode,T,dt)
    uu(1) = 1;
    tt = (0:dt:T)';

    for i = 2:T/dt+1
        temp = uu(i-1);
        for j = 1:20

            [f,dfdu] = ode(tt(i), temp);
            u = uu(i-1) + dt*0.5*(f + ode(tt(i-1),uu(i-1)));
            diff = temp - u;
            d2 = 1 - dfdu*0.5*dt;
            if (abs(diff)<10^(-14))
                break
            end
            temp = temp - d2\diff;
        end
        uu(i) = temp;
    end
end


function [f, dfdu] = ode(t,u)
    f = 2*(t^3+t)/u;
    dfdu = t^2 + 1;
end




