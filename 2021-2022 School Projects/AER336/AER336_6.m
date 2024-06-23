%% Q1 work

T = 50;
mu = 3;
dt = 0.05;
u0 = [4;0];
[tt,uu,eigv] = rk4(@vdp,T,dt,u0);

figure(1)
plot(tt,uu(:,1));
figure(2)
plot(eigv,'o');
opts = odeset('reltol',1e-11,'abstol',1e-11);
[t, uu_exact] = ode45(@vdp,[0,T],u0,opts);
k = 0;
for dt = [0.1 0.05 0.025 0.0125]
    [tt, uu] = rk4(@vdp,T,dt,u0);
    disp(uu_exact(end,1) - uu(T/dt,1))
end

%% Q2 work
n1 = 16;
n = n1^2;
A = laplacian2d(n1);
B = [zeros(n) eye(n); A zeros(n)];
ee = eig(full(B));
figure(3)
plot(ee, 'o');
xlim([-10,10])

n1 = 128;
n = n1^2;
A = laplacian2d(n1);
B = [zeros(n) eye(n); A zeros(n)];
B = sparse(B);
ee = eigs(B, 1, "largestabs", "MaxIterations", 1000);
max(ee)
clear;
T = 0.3;
dt = 0.005;
ics = load('prob3ics.mat');
x0 = ics.x0;
v0 = ics.v0;
u0 = [x0; v0];
[tt,uu] = rk4_2(@wave, T, dt, u0);
plotfield2d(uu);

%% Q1 functions
function [f, dfdu,e] = vdp(t, u)
    u1 = u(1);
    u2 = u(2);
    mu = 3;
    f = [u2; mu*(1-u1^2)*u2-u1+sin(t)];
    dfdu = [0 1; -2*mu*u1*u2-1 mu*(1-u1^2)];
    e = eig(dfdu);
end

function [tt,uu,eig] = rk4(odefun,T,dt,u0)
    tt = 0:dt:T;
    uu = zeros(length(u0), T/dt);
    uu(:,1) = u0;
    [t1,t2,eig(:,1)] = odefun(0,u0);
    for i = 1:T/dt
        K1 = odefun(tt(i), uu(:,i));
        k_2 = uu(:,i) + 0.5*dt*K1;
        K2 = odefun(tt(i)+0.5*dt,k_2);
        k_3 = uu(:,i) + 0.5*dt*K2;
        K3 = odefun(tt(i)+0.5*dt,k_3);
        k_4 = uu(:,i)+dt*K3;
        K4 = odefun(tt(i)+dt, k_4);
        uu(:, i+1) = uu(:,i) + dt*(K1/6 + K2/3 + K3/3 + K4/6);
        [t1, t2, eig(:,i+1)] = odefun(tt(i), uu(:,i));
    end
    uu = uu';
end

function [tt,uu] = rk4_2(odefun,T,dt,u0)
    tt = 0:dt:T;
    uu = zeros(length(u0), T/dt);
    uu(:,1) = u0;
    for i = 1:T/dt
        K1 = odefun(tt(i), uu(:,i));
        k_2 = uu(:,i) + 0.5*dt*K1;
        K2 = odefun(tt(i)+0.5*dt,k_2);
        k_3 = uu(:,i) + 0.5*dt*K2;
        K3 = odefun(tt(i)+0.5*dt,k_3);
        k_4 = uu(:,i)+dt*K3;
        K4 = odefun(tt(i)+dt, k_4);
        uu(:, i+1) = uu(:,i) + dt*(K1/6 + K2/3 + K3/3 + K4/6);
    end
    uu = uu';
end

%% Wave eqn

function A = laplacian2d(n1)
    h = 1/(n1+1);
    A1 = 1/h^2*spdiags([ones(n1,1),-2*ones(n1,1),ones(n1,1)],[-1,0,1],n1,n1);
    E1 = speye(n1);
    A = kron(A1,E1) + kron(E1,A1);
end

function f = wave(t, u)
    n1 = 128;
    n = n1^2;
    A2 = laplacian2d(n1);
    B2 = [zeros(n) eye(n); A2 zeros(n)];
    f = B2*u;
end

    
