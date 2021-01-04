function [x,y] = imEuler(f,t0,tN,y0,h)
    numsteps = round((tN-t0)/h);
    x = linspace(t0,tN,numsteps);
    y = zeros(1,numsteps);
    y(1) = y0;
    for n = 1:(numsteps-1)
        y1 = f(x(n),y(n));
        y2 = f(x(n+1), y(n)+h*y1);
        y(n+1) = y(n) + h*0.5*(y1+y2);
    end
end