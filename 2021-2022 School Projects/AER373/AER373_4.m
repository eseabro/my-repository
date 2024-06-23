lambda = 1;
G = 1;
L = 10;
a = linspace(0,L,100);
b = linspace(0,L,100);
[A, B] = meshgrid(a,b);
n = 0.005;

X = A + n/L .*B.*A;
Y = B - n.*(B-A);

VM = G.*n./L *sqrt(2*3*(2.*(2.*Y./L -1).^2+(Y./L-1).^2+9*(X./L-1).^2));

figure(1)
contourf(X, Y, VM, 20);
title('von Mises Stress Contour Plot (G = 1, L = 10, n = 0.005)');
xlabel('x1');
ylabel('x2');
colorbar
axis equal