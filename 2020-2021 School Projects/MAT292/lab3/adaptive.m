function [x,approx] = adaptive(f,t0,tN,y0,h)
    numsteps = round((tN-t0)/h);
    x = linspace(t0,tN,numsteps);
%   y = zeros(1,numsteps);
%   z = zeros(1,numsteps);
    approx = zeros(1,numsteps);
    approx(1) = y0;
    n=1;
    while(x(n)<tN)
        y1 = f(x(n),approx(n));
        y2 = f(x(n)+h, approx(n)+h*y1);
        Y = approx(n) + h*0.5*(y1+y2);
        
        z1 = f(x(n),approx(n));
        z2 = f(x(n)+(h/2), approx(n)+(h/2)*z1);
        Z_i = approx(n) + (h/2)*0.5*(z1+z2);
        
        z1 = f(x(n), Z_i);
        z2 = f(x(n)+(h/2), Z_i+(h/2)*z1);
        Z = Z_i + (h/2)*0.5*(z1+z2);
        
        tol = 1e-8;
        D = Z-Y;
        if (abs(D)<tol)
            approx(n+1) = Z+D;
            h = 0.9*h*min(max(tol/abs(D),0.3),2);
            n=n+1;
            x(n) = x(n-1) +h;

        else
            h = 0.9*h*min(max(tol/abs(D),0.3),2);
        end
    end
end