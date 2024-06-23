W = 2.83176*10^6;
I_x = 0.247*10^8;
I_y = 0.449*10^8;
I_xx = -0.212*10^7;
U_e = 235.9;
theta_e = 0;

m = 2.83176*10^6/9.8;
g = 9.8;

X_u = -1.982*10^3;
X_w = 4.025*10^3;
X_q = 0;
X_de = -16.5299;
X_dp = 8.4953*10^5;

Z_u = -2.595*10^4;
Z_w = -9.030*10^4;
Z_q = -4.524*10^5;
Z_wd = 1.909*10^3;
Z_de = -1.5794*10^6;
Z_dp = 0;

M_u = 1.593*10^4;
M_w = -1.563*10^5;
M_q = -1.521*10^7;
M_wd = -1.702*10^4;
M_de = -5.204*10^7;
M_dp = 0;

A = [X_u/m  X_w/m  0  -g*cos(theta_e);  ...
    Z_u/(m-Z_wd) Z_w/(m-Z_wd) (Z_q +m*U_e)/(m-Z_wd) (-m*g*sin(theta_e)/(m-Z_wd)); ...
    (M_u+(Z_u/(m-Z_wd))*M_wd)/I_y (M_w + (Z_w/(m-Z_wd))*M_wd)/I_y (M_q + ((Z_q +m*U_e)/(m-Z_wd))*M_wd)/I_y (-(m*g*sin(theta_e)*M_wd/(m-Z_wd))/I_y); ...
    0 0 1 0];
B = [X_de/m X_dp/m;...
    Z_de/(m-Z_wd) Z_dp/(m-Z_wd);...
    (M_de+(Z_de/(m-Z_wd))*M_wd)/I_y (M_dp+(Z_dp/(m-Z_wd))*M_wd)/I_y;...
    0 0];


C = eye(4);

D = zeros(4,2);

sys = ss(A,B,C,D);
fun1 = tf(sys);



%%Q2:Short period mode


A2 = [Z_w/(m-Z_wd) (Z_q +m*U_e)/(m-Z_wd); ...
    (M_w + (Z_w/(m-Z_wd))*M_wd)/I_y (M_q + ((Z_q +m*U_e)/(m-Z_wd))*M_wd)/I_y; ];
B2 = [Z_de/(m-Z_wd) Z_dp/(m-Z_wd);...
    (M_de+(Z_de/(m-Z_wd))*M_wd)/I_y (M_dp+(Z_dp/(m-Z_wd))*M_wd)/I_y;];

C2 = eye(2);

D2 = zeros(2,2);

sys2 = ss(A2,B2,C2,D2);
fun2 = tf(sys2);


%% Q3: Step Response
figure(1)
step(fun1(2,1)*(1/U_e))
hold on
step(fun2(1,1)*(1/U_e))
hold off;
xlim([0,30])
ylim([-2 1])


%% Q4 PID control
figure(2)
rlocus(fun1(2,1)*(1/U_e));

figure(3)
rlocus(fun2(1,1)*(1/U_e));
s = tf('s');

figure(4)
step(fun1(2,1)*(1/U_e))
hold on
K = 1/235.9;
b = 0.0047;
T = 0.004027;
C = (s^2+T)/(s^2+b);
fun4 = fun2(1,1)*(C)*(1/U_e);
step(fun4)
hold off;
xlim([0,300])
ylim([-2 1])


