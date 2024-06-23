function [T] = schedule(Tstart,c,t)
%% Inputs
% Tstart     - design variable vector
% c          - cooling schedule parameter 0<c<1
% t          - time

%% Outputs
% T          - Temperature at time t

T = Tstart*c^t;


end