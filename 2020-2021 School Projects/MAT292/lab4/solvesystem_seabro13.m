function [t,y] = solvesystem_seabro13(f1,f2,t0,tN,x0,h)
    numsteps = round((tN-t0)/h);
    
    t = linspace(t0, tN, numsteps);
    
    y = zeros(2,numsteps);
    
    y(1,1) = x0(1);
    y(2,1) = x0(2);

    for n = 1:(numsteps-1)
        y1_1 = f1(t(n), y(1,n), y(2,n));
        y1_2 = f2(t(n), y(1,n), y(2,n));

        
        y2_1 = f1(t(n+1), y(1,n)+h*y1_1, y(2,n)+h*y1_2);
        y2_2 = f2(t(n+1), y(1,n)+h*y1_1, y(2,n)+h*y1_2);

        y(1,n+1) = y(1,n) + h*0.5*(y1_1+y2_1);        
        y(2,n+1) = y(2,n) + h*0.5*(y1_2+y2_2);
    end
        
end