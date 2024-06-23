clear;
c = 1;
gamma = 1.4;
p_true = @ (M) (1 + M^2 *(gamma-1)/2)^(-(gamma)/(gamma-1));

for j = linspace(0,4,8001)
    p(c) = mach2pressure_pwl(j);
    err(c) = abs(p_true(j) - p(c));
    c = c +1;

end

figure(1)
Ms = linspace(0,4,8001);
plot(Ms,p);
xlabel('Mach Number')
ylabel('Pressure Ratio')

figure(2)
plot(Ms,err);
xlabel('Mach Number')
ylabel('Error')


T = readtable('rae2822geom.dat');

xs = [table2array(T(end:-1:2,1));table2array(T(:,1))];
ys = [table2array(T(end:-1:2,3)); table2array(T(:,2))];
li = arclength(xs,ys);

lp = linspace(li(1),li(end),10001);

x_c = spline(li,xs,lp);
y_c = spline(li,ys,lp);


figure(1), clf,
plot(x_c,y_c); hold on;
plot(xs,ys,'o');
axis equal;

hold off;

figure(2)
plot(x_c,y_c); hold on;
plot(xs,ys,'o');
axis([-0.02,0.02,-0.02,0.02]);






function p = mach2pressure_pwl(M)
    Mach = linspace(0,4,9);
    P0 = [1,0.843019175422553, 0.528281787717174, 0.272403066476657, 0.127804525462951,...
        0.058527663465935, 0.027223683703863, 0.013110919994476, 0.006586087307989];
    i = 2;
    while M > Mach(i)
        i = i + 1;
    end
    p = P0(i-1) + ((P0(i) - P0(i-1))/(Mach(i) - Mach(i-1)))*(M-Mach(i-1));
end


function li = arclength(xi,yi)
    for i = 2:length(xi)

        li2(i) = sqrt((xi(i)-xi(i-1))^2 + (yi(i)-yi(i-1))^2);
        
    end
    li = cumsum(li2');
end

