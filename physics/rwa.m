function [soln impact_times] = rwa(P)
% function soln = rwa(P)
% rwa solves the equations of motions for a rimless wheel specified
% by P. P must be a struct that contains:
%  
% P.time, time to simulate
% P.initialc, vector of initial conditions
%
% Ryan George
% COMO 401 Assignment Three

%improve tolerance level, specify event
options = odeset('RelTol', 1e-5, 'AbsTol', 1e-6, 'Events', @rwaslam);

initialc = P.initialc;
total_time = P.time;
cur_time = 0;
k=1;

while cur_time < total_time %while simulation is incomplete

    %solve the next 'chunk' of solution; i.e. until event
    soln{k} = ode45(@rwa_ode, [cur_time  total_time], initialc, options, P);
    
    %if ode45 ceases, either the simulation is done, or the event has been
    %triggered. In the case of the latter, calculate post-impact state
    %variables using impact_fcn
    initialc = rwaimpact_fcn(P,soln{k}.y(:,end));

    %update current time and 'chunk' (k)
    cur_time = soln{k}.x(end);
    
    if cur_time<total_time
        impact_times(k)=soln{k}.xe;
    end
    k = k+1;
end


function x_prime = rwa_ode(t, x, P)
% function x_prime = simpend_ode(t, x, P)
% simpend_ode gives the values of x_prime = [dx/dt d^2x/dt^2] at the point
% x.

g = 981; %cm/s^2

%governed by SHM equation d^2theta/dx^2 + (g/r)sin(theta) == 0
x_prime = [x(2); (P.totalmass*g*P.totalr/P.inertia)*sin(x(1))];

function [value  isterminal  direction] = rwaslam(t,x,P)
beta = pi/P.nlegs;
value = x(1) - (beta + P.alpha); %becomes zero when leg hits ground
direction = 1; %detect only when theta surpasses beta + P.alpha
isterminal(1) = 1;
