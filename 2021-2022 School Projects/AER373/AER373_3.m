L=10;
n=0.1;
p0 = 7.85;

a = linspace(0,L,1000);
b = linspace(0,L,1000);
[A,B] = meshgrid(a,b);

% Set up mapping
X = (1-2*n).*A -n.*B +3.*n./L .*A.*B + n.*L;
Y = (1+n).*B - n./L .*A.*B;

% E'
E_11 = -5.*n/3 +2.*n.*B/L +n.*A./(3.*L);
E_22 = 4.*n/3 - 2.*n.*A./(3.*L) -n.*B./L;
E_12 = n/2.*((3.*A-B)./L-1);

E_e = sqrt(2/3*( (E_11).^2 +2*(E_12).^2 + (E_22).^2));

figure(1)
contourf(X,Y,E_e,20);
title('Contour Plot of Equivalent Strain L = 10; n = 0.1');
xlabel('x1');
ylabel('x2');

figure(2)

dens = p0./(2*n^2./L .*(X+Y-L) +n./L.*((-X)+3.*Y-L)+1);
contourf(X,Y,dens,'Fill','on');
title('Contour Plot of Density. \rho = 7.85; L = 10; n = 0.1-');
xlabel('x1');
ylabel('x2');
colorbar
axis equal;