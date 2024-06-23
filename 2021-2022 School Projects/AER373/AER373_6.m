sig_11 = 30;
a = 2;
s_rr = @(r,theta) 2.*sig_11 .*(1-a.^2./r.^2)+ 2.*sig_11.*(1+3.*a.^4./r.^4 -4.*a.^2./r.^2).*cos(2*theta);
s_tt = @(r,theta) 2.*sig_11 .*(1+a.^2./r.^2)- 2.*sig_11./2.*(1+3.*a.^4./r.^4).*cos(2.*theta);
s_rt = @(r,theta) sig_11 .*(1-3.*a.^4./r.^4 +2.*a.^2./r.^2).*sin(2.*theta);




r = linspace(a,6*a);
theta = linspace(0, pi/2);


[R,T] = meshgrid(r,theta);

x = r'*cos(theta);
y = r'*sin(theta);


% 
figure(1)
contourf(x,y,s_rr(R,T));
xlabel('x1')
ylabel('x2')
title('\sigma_r_r')
colorbar

figure(2)
contourf(x,y,s_tt(R,T));
xlabel('x1')
ylabel('x2')
title('\sigma_\theta_\theta')
colorbar

figure(3)
contourf(x,y,s_rt(R,T));
xlabel('x1')
ylabel('x2')
title('\sigma_r_\theta')
colorbar


%%Q2.
a = 0.5;
L = 10;
x1 = linspace(0,L);
x2 = linspace(0,L);

[X,Y] = meshgrid(x1,x2);
sig_0 = a./3 .*(X.^2/L +Y.*(Y./L +1));


figure(4)
contourf(X,Y,sig_0);
xlabel('x1')
ylabel('x2')
title('Hydrostatic Stress, a = 0.5')
colorbar

%%Q3
clear;
P = 20;
L = 10;
E = 12;
v = 15;
x1 = linspace(-L,L);
x2 = linspace(0,-L);

[X,Y] = meshgrid(x1,x2);

sig_11 = -P/pi .* (2.*X.^3./((Y.^2+X.^2).^2));
sig_22 = -P/pi .* (2.*Y.^2 .*X./((Y.^2+X.^2).^2));
sig_12 = -P/pi .* (2.*X.^2.*Y./((Y.^2+X.^2).^2));

eps_11 = 1/E * (sig_11 - v*sig_22);
eps_22 = 1/E * (sig_22 - v*sig_11);
eps_12 = (1+v)/E * sig_12;

figure(5)
contourf(X,Y,sig_11);
xlabel('x1')
ylabel('x2')
title('\epsilon_1_1 P = 20, E=12, v= 15')
colorbar

figure(6)
contourf(X,Y,sig_22);
xlabel('x1')
ylabel('x2')
title('\epsilon_2_2 P = 20, E=12, v= 15')
colorbar

figure(7)
contourf(X,Y,sig_12);
xlabel('x1')
ylabel('x2')
title('\epsilon_1_2 P = 20, E=12, v= 15')
colorbar



