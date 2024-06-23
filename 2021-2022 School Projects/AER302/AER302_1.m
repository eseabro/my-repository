r = 6.3781e6;
h(1) = 0;
h_G(1) = 0;
T(1) = 288.16;
P(1) = 1.01325e5;
rho(1) = 1.225;
a(1) = -6.5e-3;
a(2) = 3e-3;
a(3) = -4.5e-3;
a(4) = 4e-3;
for i = 2:100001
    h(i) = (i-1)*10^2;
    h_G(i) = (r*h(i))/(r-h(i));
    T(i) = temp(T,h,i,a);
    P(i) = pres(P,T,h,i,a);
    rho(i) = dens(rho,T,h,i,a);
end
Tot = table(h',h_G', T', P', rho');
Tot.Properties.VariableNames{'Var1'} = 'h(km)';
Tot.Properties.VariableNames{'Var2'} = 'h_G(km)';
Tot.Properties.VariableNames{'Var3'} = 'Temperature (K)';
Tot.Properties.VariableNames{'Var4'} = 'Pressure (N/m^2)';
Tot.Properties.VariableNames{'Var5'} = 'Density (kg/m^3)';
writetable(Tot,'output.xlsx','Sheet','MyNewSheet');

function t = temp(T,h,i,a)
    if h(i) <= 11e3
        t = T(1) + a(1)*h(i); 

    elseif (11e3 < h(i))&& (h(i) <= 25e3)
        t = T(12);

    elseif (25e3 < h(i))&& (h(i) <= 47e3)
        t = T(26) + a(2)*(h(i)-h(26));

    elseif (47e3 < h(i))&& (h(i) <= 53e3)
        t = T(48);

    elseif (53e3 < h(i))&& (h(i) <= 79e3)
        t = T(54) + a(3)*(h(i)-h(54));

    elseif (79e3 < h(i))&& (h(i) <= 90e3)
        t = T(80);

    else
        t = T(91) + a(4)*(h(i)-h(91));
    end
end

function p = pres(P,T,h,i,a)
    if h(i) <= 11e3
        p = P(1)*(T(i)/T(1))^(-9.81/(287*a(1))); 

    elseif (11e3 < h(i))&& (h(i) <= 25e3)
        p = P(12)*exp(((-9.81)/(287*T(i))*(h(i)-h(12))));

    elseif (25e3 < h(i))&& (h(i) <= 47e3)
        p = P(26)*(T(i)/T(26))^(-9.81/(287*a(2))); 

    elseif (47e3 < h(i))&& (h(i) <= 53e3)
        p = P(48)*exp(((-9.81)/(287*T(i))*(h(i)-h(48))));

    elseif (53e3 < h(i))&& (h(i) <= 79e3)
        p = P(54)*(T(i)/T(54))^(-9.81/(287*a(3))); 

    elseif (79e3 < h(i))&& (h(i) <= 90e3)
        p = P(80)*exp(((-9.81)/(287*T(i))*(h(i)-h(80))));

    else
        p = P(91)*(T(i)/T(91))^(-9.81/(287*a(4))); 
    end
end

function rh = dens(rho,T,h,i,a)
    if h(i) <= 11e3
        rh = rho(1)*(T(i)/T(1))^(-(9.81/(a(1)*287)+1)); 

    elseif (11e3 < h(i))&& (h(i) <= 25e3)
        rh = rho(12)*exp(((-9.81)/(287*T(i))*(h(i)-h(12))));

    elseif (25e3 < h(i))&& (h(i) <= 47e3)
        rh = rho(26)*(T(i)/T(26))^(-(9.81/(a(2)*287)+1)); 

    elseif (47e3 < h(i))&& (h(i) <= 53e3)
        rh = rho(48)*exp(((-9.81)/(287*T(i))*(h(i)-h(48))));

    elseif (53e3 < h(i))&& (h(i) <= 79e3)
        rh = rho(54)*(T(i)/T(54))^(-(9.81/(a(3)*287)+1)); 

    elseif (79e3 < h(i))&& (h(i) <= 90e3)
        rh = rho(80)*exp(((-9.81)/(287*T(i))*(h(i)-h(80))));

    else
        rh = rho(91)*(T(i)/T(91))^(-(9.81/(a(4)*287)+1)); 
    end
end