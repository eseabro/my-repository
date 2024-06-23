function [f] = objfcn(xx)
%% Inputs
% x     - design variable vector

%% Outputs
% f     - function evaluated at x

m = 10;

for i = 1:length(x)
	fval(i) = sin(xx(i)) * (sin(i*xx(i)^2/pi))^(2*m);
end

f = -sum(fval);

end