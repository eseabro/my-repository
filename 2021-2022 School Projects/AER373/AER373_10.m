A = 1;
L = 1;
x = 0:0.1:L;
p = 1;
g = -1;
u = p.*g.*L.*x./A - p.*g.*x.^2./(2*A);

x1 = 0:0.1:L/2;
x2 = L/2:0.1:L;

u1 = -3/4.*x1;%.*x1.*p.*g./A;
u2 = -1/4.*x2 -1/4;%.*x2.*p.*g./A;

plot(x,u);
hold on
plot(x1,u1);
plot(x2,u2);
legend('Exact', 'Segment 1', 'Segment 2');
