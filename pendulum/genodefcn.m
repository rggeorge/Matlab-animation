 function soln = genodefcn(P, massmtx_fcn, extfce_fcn, inertialconsfce_fcn, constrfce_fcn, co_fcn, impact_fcn, eventval_fcn)
% genodefcn is a generic ode function that solves a dynamical system.
% The input is a structure P of parameters, and several function handles.
% These functions are:
% massmtx_fcn - calculates mass matrix from state variables
% extfce_fcn - caluculates external force on system
% inertialconsfce_fcn - calculates inertial/conservative forces on system
% constrfce_fcn - calculates possible constraint force on system
% co_fcn - calculates whether constraint is on of off
% impact_fcn - calculates state variables immediately after impact
% eventval_fcn - sets value for event function
%
%
% Ryan George
% COMO 401, Assignment Two

%add function handles to P
P.massmtx = massmtx_fcn;
P.extfce_fcn = extfce_fcn;
P.inertialconsfce_fcn = inertialconsfce_fcn;
P.eventval_fcn = eventval_fcn;
P.constrfce_fcn = constrfce_fcn;
P.co_fcn = co_fcn;

%set ode options, including event function
options = odeset('RelTol', 1e-1, 'AbsTol', 1e-1, 'Events', @ode_eventfcn);

%initialize time and initial conditions
total_time = P.time;
k = 1;
cur_time = 0;
initialc = P.initialc;

while cur_time < total_time %while simulation is incomplete

    %solve the next 'chunk' of solution; i.e. until event
    soln{k} = ode45(@genode, [cur_time  total_time], initialc, options, P);
    
    %if ode45 ceases, either the simulation is done, or the event has been
    %triggered. In the case of the latter, calculate post-impact state
    %variables using impact_fcn
    initialc = impact_fcn(P, soln{k}.y(:,end));
    
    %update current time and 'chunk' (k)
    cur_time = soln{k}.x(end);
    k = k+1;
end



function xprime = genode(t, x, P)
%function xprime = genode(t, x, P)
%genode is a generic ode input/output function that returns values to ode45
%or a similar solver.
%
%input:
%x(2n + 1) represents q_(n-1)
%x(2n) represents q'_n
%
%output:
%xprime(2n + 1) represents q'_(n-1)
%xprime(2n) represents q''_n

%calculate uncontstrained force and constrained force
ext_fce = P.extfce_fcn(P, x);
constr_fce = P.constrfce_fcn(P, x);
inertialcons_fce = P.inertialconsfce_fcn(P, x);

%set up xprime vector
xprime = zeros(size(x));
%shift x' values into xprime(1:2:end)
xprime(1:2:end) = x(2:2:end);

if P.co_fcn(x,P, constr_fce) %if constraint force is on
    %acceleration = inverse (mass matrix) * (total force)
    xprime(2:2:end) = P.massmtx(P, x)\(ext_fce - inertialcons_fce + constr_fce);
    
else %if constraint force is off
     %acceleration = inverse (mass matrix) * (total force)
    xprime(2:2:end) = P.massmtx(P, x)\(ext_fce - inertialcons_fce);
end



function [value  isterminal  direction] = ode_eventfcn(t, q ,P)
% function [value  isterminal  direction] = ode_eventfcn(t,x,P)
%
% ode_eventfcn is an event function that tells ode45 in genode_fcn.m when
% to cease.  This event function is NOT generic; the expressions for 'value'
% and 'direction' must be set specifically for the system at hand.

%value is how far mass 1 is from pulling the string taught; 
%i.e. how close to the circle
value(1) = P.eventval_fcn(P,q) ; 
isterminal(1) = 1;
direction(1) = 1; %only stop when the string becomes tight; not when m1 falls off