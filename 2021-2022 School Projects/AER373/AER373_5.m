L = 10;
a = linspace(0,L,100);
b = linspace(0,L,100);
[X, Y] = meshgrid(a,b);

K = 1;

sig_o = K/3 * (-X.^2./2 - L*X + Y.^2./2 +X.*Y);

sig_11 = K*(X.^2 ./2 - L.*X);
sig_22 = K*(Y.^2 ./2 - X.^2 +X.*Y);
sig_12 = K*(X.*Y + X.^2 ./2 - L.*Y);

s_11 = sig_11 - sig_o;
s_22 = sig_22 - sig_o;
s_12 = sig_12;

J2 = 1/2 * (s_11.^2 + s_22.^2 + 4.*s_12.^2);

VM = sqrt(3*J2);


figure(1)
contourf(X, Y, sig_o, 20);
title('Hydrostatic Stress Contour Plot');
xlabel('x1');
ylabel('x2');
colorbar
axis equal

figure(2)
contourf(X, Y, VM, 20);
title('Von Mises Contour Plot');
xlabel('x1');
ylabel('x2');
colorbar
axis equal