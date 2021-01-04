function [t,y] = DE2_seabro13(t0,tN,y0,y1,h,f)
    numsteps = round((tN-t0)/h);
    t = linspace(t0,tN,numsteps);
    y = zeros(1,numsteps);
    y_p = zeros(1,numsteps);
    y_2p = zeros(1,numsteps);
    y(1) = y0;
    y_p(1) = y1;
    y(2) = y0 + y1*h;
    y_p(2) = y1+h*f(t0,y0,y1);
    y_2p(2) = f(t(2),y(2),y_p(2));

    for n=2:numsteps-1
        y(n+1) = y_2p(n)*h^2 + 2*y(n) - y(n-1);
        y_p(n+1) = y_2p(n)*h +y_p(n);
        y_2p(n+1) = f(t(n+1),y(n+1),y_p(n+1));

    end
end