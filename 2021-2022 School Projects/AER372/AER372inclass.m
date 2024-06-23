s = tf('s');
gain = 1; 
sigma =  11;
omegan = 4;
sigma1 =  0.5;

% p1 = sigma + 2*(omegad)*i;
% p2 = sigma - 2*(omegad)*i;
% p1_ = sigma1 + (omegad)*i;
% p2_ = sigma1 - (omegad)*i;
% z1 = 1;
% z2 = 0.2;
% 
% pa1 = 0.5;
% pa2 = 2;
% 
% G0 = gain*(p1*p2) / ((s+p1)*(s+p2));
% G01 = gain*(p1_*p2_) / ((s+p1_)*(s+p2_));
% 
% Gz = (gain/z1)*(p1*p2*(s+z1))/((s+p1)*(s+p2));
% 
% Gp = gain*(p1*p2*pa1)/((s+p1)*(s+p2)*(s+pa1));
G0 = omegan^2 / (s^2+2*sigma*omegan*s+omegan^2);
G1 = omegan^2 / (s^2+2*sigma1*omegan*s+omegan^2);

figure(1)
stepplot(G0); grid
hold on;
stepplot(G1); grid

legend('og', 'lefter pole')
figure(2)
impulse(G0); 
hold on;
impulse(G1); 

% stepplot(G0, Gz); grid