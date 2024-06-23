function [z] = move(x, lb, ub, epsilon)
%
% [z] = move(x, lb, ub, epsilon)
%
% This matlab function randomly perturbs the design variable
% vector x such that the perturbed vector satisfies the bound 
% constraints. 
%
% Inputs: 
% ------
% x:      Design variable vector
%
% lb:      Vector containing lower bounds on the design variables
%
% ub:      Vector containing upper bounds on the design variables
%
% epsilon: A parameter controlling the magnitude of perturbation.
%          It is recommended that this parameter is set to a value 
%          between 0.1 and 0.3 if the design variables are normalized to
%          [0,1]. Try some typical values and see what impact 
%          this parameter makes on the convergence trends.
%
% Output:
% ------
% z:  perturbed design variable vector satisfying the bound constraints 
%
%
  n = length(x);  % Extract the number of design variables
  flag = 0;
  while flag == 0
        ind = ceil(rand*n); % randomly generate an integer between 1 and n
                            % to select the design variable that will be 
                            % perturbed to generate the move
        z = x;

        z(ind) = x(ind) + epsilon*(-1 + rand*2);   % Perturb the randomly chosen 
                                                   % design variable by epsilon*U[-1,1]

        if ((z(ind) < lb(ind)) || (z(ind) > ub(ind)))   % If bound constraints are violated
           flag = 0;                               % generate a new perturbation
        else                                       
           flag = 1;
        end
  end

