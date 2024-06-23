%%Q3
syms s g y0 m R L
A = [s -1 0; -2*g/y0 s 2/y0*sqrt(g/m); 0 0 s+R/L];
disp(inv(A))

%%Q4
clear;
syms g m s y0 R L t
G = 2*sqrt(g/m)/((R+L*s)*(2*g-y0*s^2));
g_l = ilaplace(G);

y0 = 1;
g = 9.8;
m = 1;
R = 3;
L = 1;
g_t = matlabFunction(g_l);
g_t2 = g_t(L, R, g, m, t, y0);

figure(1)
fplot(g_t2, [0,1]);
xlabel('t')
ylabel('g(t)')
title('Impulse Response')




%%%%%%% Actual Lab section




A = [0 1 0; 2*g/y0 0 -2/y0*sqrt(g/m); 0 0 -R/L];
b = [0;0;1];
c_t = [1 0 0];
d = 0;

[b,a] = ss2tf(A,b,c_t, d);

f = b(4)./a;
roots(a)


x0 = [1;0;sqrt(9.8)]
[A,B,C,D]=linmod("magball",x0,3*1*sqrt(9.8*1))

impulse(ss(A,B,C,D),1)
step(ss(A,B,C,D),1)

