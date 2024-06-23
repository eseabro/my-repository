%Q3.2
syms s
s = tf('s');
K = 20;

G1 = K/(s*(s^2 + 4*s +5));
rlocus(G);


%%Q3.3
a = 0;
b = 0;
G2 = (s^2+(5/6)*s+(1/3))/(s^3*(s^2+(6+a)*s+(16+b)));
rlocus(G);


a = 0;
b = 1;
G3 = (s^2+(5/6)*s+(1/3))/(s^3*(s^2+(6+a)*s+(16+b)));
rlocus(G);


a = 1;
b = 0;
G4 = (s^2+(5/6)*s+(1/3))/(s^3*(s^2+(6+a)*s+(16+b)));
rlocus(G);

%Q 3.4
G = 1/(s^3+9*s^2+18*s);
rlocus(G);

%%Q3.5

G = -1/(s^2*(s+5));
rlocus(G);

%3.5c
K=25/4;
L = 1/(s^3+5*s^2+K*s);
rlocus(L)
%3.5d

K = 1.4165;
Kt = 5;
G = 1/(1+K*((s^3+5*s^2)/(s^3+5*s^2+Kt*s)));
step(G)
stepinfo(G)



%%Q3.6: 
G = 1/((s+1)*(s+5));

z1 = 1;
z2 = 6;
G_c = (s + z1)*(s + z2)/s;

L = G_c*G;
rlocus(L);

K = 10;
k_i = K*z1*z2
k_p = K*(z1 + z2)
k_d = K
K_v = z1*z2*K/(1*5);
disp('Steady State Error (Ramp)')
r = 1/K_v


