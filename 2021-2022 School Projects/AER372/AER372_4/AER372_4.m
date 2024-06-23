%% Q1 we want: PM ≥50◦ and ωBW ≥20 rad/sec
syms s;
s = tf('s');
G = 50000/(s*(s+10)*(s+50));
bode(G);
K = 1;
a = 0.1;
T = 0.3162;
D_c = K*(T*s+1)/(a*T*s+1); %Lead Compensator
bode(C*G);
[K_gm, Phi_pm, omega_pc, omega_gc] = margin(C*G);
disp(Phi_pm);
disp(omega_gc);


%% Q2 we want: PM ≥35◦
syms s;
s = tf('s');
G = 10/(s*(s/1.4+1)*(s/3+1));
bode(G);
[K_gm, Phi_pm, omega_pc, omega_gc] = margin(G)

T = 25;
a = 9;
D_c = (T*s+1)/(a*T*s+1); %Lead Compensator

bode(D_c*G);
[K_gm, Phi_pm, omega_pc, omega_gc] = margin(D_c*G)


%% Q3 we want: GM ≥35◦
syms s;
s = tf('s');
G = 0.05*(s+25)/(s^2*(s^2+0.15*s+4));
bode(G);
[K_gm, Phi_pm, omega_pc, omega_gc] = margin(G);

T = 1/10;
a = -20;
D_c = (T*s+1)/(a*T*s+1); %Lag Compensator

bode(D_c*G);
[K_gm, Phi_pm, omega_pc, omega_gc] = margin(D_c*G)

%% Q4 we want: w_c = 31.6 rads/sec
syms s;
s = tf('s');
G = 1/(s*(s/20 +1)*(s^2/(100^2) + 0.5*s/100 +1));
bode(G);
hold on
[K_gm, Phi_pm, omega_pc, omega_gc] = margin(G);

a = 1/5;
T = 1/20;
K = 30.25;


D_c = K*(T*s+1)/(a*T*s+1);

[K_gm, Phi_pm, omega_pc, omega_gc] = margin(D_c*G);
a = 0;  
K = 2.34;
D_c2 = K;
bode(D_c*G*D_c2)
hold on
[K_gm, Phi_pm, omega_pc, omega_gc] = margin(D_c*G*D_c2);

z = 7.555; 
p = 3.16;  
K = 2.34;
D_c3 = K*(s/z+1)/(s/p+1);
[K_gm, Phi_pm, omega_pc, omega_gc] = margin(D_c*G*D_c3)
bode(D_c*G*D_c3)
legend('G', 'Lead', 'Lead and Lag');
%% Q5 we want: Kv = 100; PM>45
syms s;
s = tf('s');
G = 10/(s*(s/10 + 1));
% bode(G);
[K_gm, Phi_pm, omega_pc, omega_gc] = margin(G);

K = 10;
% bode(10*G);
[K_gm, Phi_pm, omega_pc, omega_gc] = margin(10*G);
T_1 = 0.1;
a = 0.001;
T_2 = 0.1;    
b = 4;
% for T_1 = 10:10:500
D_c = K*b*(T_1*s+1)*(T_2*s+1)/((a*T_1*s+1)*(b*T_2*s+1));
%     
%     [K_gm, Phi_pm, omega_pc, omega_gc] = margin(D_c*G);
%     disp(a);
%     disp(Phi_pm);
% end
bode(D_c*G)
[K_gm, Phi_pm, omega_pc, omega_gc] = margin(D_c*G);
disp(Phi_pm);



