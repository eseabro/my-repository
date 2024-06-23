%%Q2: 
clear;
L = [5 0 0; 2 4 0; 1 7 3];
U = [3 7 1; 0 4 2; 0 0 5];
b1 = [5; 2; 10];
b2 = [10; 2; 5];
x = myforwardsub(L,b1)
y = mybackwardsub(U,b2)


A = [2 1 0; -1 2 -1; 0 -1 3];
[L, U] = mylu(A)

x = mylinearsolver(A,b1);


%%Q3: 

flag = 1;
m = [3 5 9];
for i = 1:3

    [A,b] = poisson.getmatvec(m(i),flag);
    x = mylinearsolver(A,b);
    
    poisson.vizsoln(x, flag);
    
    sym(i) = issymmetric(A)
    vals(i) = all(eig(A) > 0)
end

flag = 1;
m = 18;

[A,b] = poisson.getmatvec(m,flag);
x = mylinearsolver(A,b);
figure(1)
poisson.vizsoln(x, flag);

flag = 0;
m = 18;

[A,b] = poisson.getmatvec(m,flag);
x = mylinearsolver(A,b);
figure(2)
poisson.vizsoln(x, flag);

% 
time = [0];
flag = 1;
m = [10:2:30];
for i = 1:length(m)
    tic
    [A,b] = poisson.getmatvec(m(i),flag);
    x = mylinearsolver(A,b);
    time(i) = toc;
end
figure(3)
poisson.vizsoln(x, flag);

figure(4)
plot(log(m),log(time));
xlabel('m')
ylabel('time for LU sub')

time1 = [0];
flag = 1;
m = [10:2:30];
for i = 1:length(m)
    [A,b] = poisson.getmatvec(m(i),flag);
    [x,temp,L] = mylinearsolver(A,b);
    time1(i) = temp;
    Ls(i) = size(L,1);
end

figure(433)
plot(log(Ls),log(time1));
xlabel('L')
ylabel('time for forward Sub')



%%Q4: Regression
clear;
dt = 0.05;
T = 10;
y = signal_sampler(dt, T);

t = 0:0.05:T;

X = ones(201,3);
X(:,1) = cos(2*t);
X(:,2) = sin(2*t);
X(:,3) = 1;


% ft = fittype('a*cos(2*x)+b*sin(2*x)+c');
% [curve] = fit(t',y,ft)

beta = (X'*X)\(X' * y);

y_hat = beta(1).*cos(2*t) + beta(2).*sin(2*t) + beta(3);


figure(6)
plot(t,y,'o');
hold on;
% plot(curve);
plot(t, y_hat)
xlabel('t');
ylabel('y');

m = 201;
% y_hat = curve(t);
stddev = sqrt((norm((y_hat - y),2))./(m-3));

sig = stddev^2*(X'*X)^(-1);



for i = 1:3
    h_hat(i) = (0.5+0.95/2)*tinv(0.95,198).*sqrt(sig(i,i));

end

disp('Ia:')
disp(beta(1) - h_hat(1))
disp(beta(1) + h_hat(1))
disp('hw:')
disp(h_hat(1))
disp('Ib:')
disp(beta(2) - h_hat(2))
disp(beta(2) + h_hat(2))
disp('hw:')
disp(h_hat(2))
disp('Ic:')
disp(beta(3) - h_hat(3))
disp(beta(3) + h_hat(3))
disp('hw:')
disp(h_hat(3))



%%Q4: Regression
clear;
dt = 0.05;
T = 1000;
y = signal_sampler(dt, T);

t = 0:0.05:T;

X = ones(length(y),3);
X(:,1) = cos(2*t);
X(:,2) = sin(2*t);
X(:,3) = 1;

beta = (X'*X)\(X' * y);

y_hat = beta(1).*cos(2*t) + beta(2).*sin(2*t) + beta(3);


figure(7)
plot(t,y,'o');
hold on;
plot(t, y_hat)
xlabel('t');
ylabel('y');

m = length(y);
stddev = sqrt((norm((y_hat - y),2))./(m-3));

sig = stddev^2*(X'*X)^(-1);



for i = 1:3
    h_hat(i) = (0.5+0.95/2)*tinv(0.95,198).*sqrt(sig(i,i));

end

disp('Ia:')
disp(beta(1) - h_hat(1))
disp(beta(1) + h_hat(1))
disp('hw:')
disp(h_hat(1))
disp('Ib:')
disp(beta(2) - h_hat(2))
disp(beta(2) + h_hat(2))
disp('hw:')
disp(h_hat(2))
disp('Ic:')
disp(beta(3) - h_hat(3))
disp(beta(3) + h_hat(3))
disp('hw:')
disp(h_hat(3))




function x = myforwardsub(L,b)
    x = zeros(1, length(b));
    for i = 1:length(b)
        x(i) = b(i);
        for j = 1:i-1
            x(i) = x(i) - L(i,j)*x(j);
        end
        x(i) = x(i)/L(i,i);
    end
end

function x = mybackwardsub(U,b)
    x = zeros(1, length(b));
    for i = length(b):-1:1
        x(i) = b(i);
        for j = i+1: length(b)
            x(i) = x(i) - U(i,j)*x(j);
        end
        x(i) = x(i)/U(i,i);
    end
end

function [L, U] = mylu(A)
    U = A;
    L = eye(size(A,1));
    for i = 1:size(A,1)-1
        for j = i+1:size(A,1)
            L(j,i) = U(j,i)/U(i,i);
            for k = 1:size(A,1)
                U(j,k) = U(j,k) - L(j,i)*U(i,k);
            end
        end
    end
end

function [x,temp,L] = mylinearsolver(A,b)
    [L, U] = mylu(A);
    tic;
    z = myforwardsub(L,b);
    temp = toc;
    x = mybackwardsub(U,z);
end


