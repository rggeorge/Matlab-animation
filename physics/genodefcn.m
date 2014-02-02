 function soln = genodefcn(P, massmtx_fcn, unconstrfce_fcn, constrfce_fcn, normal_fcn, co_fcn)
%soln = genodefcn(P, massmtx_fcn, unconstrfce_fcn, constrfce_fcn, normal_fcn, impact_fcn, co_fcn)
%
% genodefcn is a generic ode function that solves a dynamical system.
% The input is a structure P of parameters, and several function handles.
% These functions are:
% massmtx_fcn - calculates mass matrix from state variables
% unconfce_fcn - caluculates unconstrained force on system
% constrfce_fcn - calculates possible constraint force on system
% normal_fcn - calculates the normal-to-constraint vector
% impact_fcn - calculates state variables immediately after impact
% co_fcn - determines whether, with the current state, the constraint is on
%
%
% Ryan George
% COMO 401, Assignment Two

%add function handles to P
P.massmtx = massmtx_fcn;
P.unconstrfce_fcn = unconstrfce_fcn;
P.constrfce_fcn = constrfce_fcn;
P.normal_fcn = normal_fcn;
P.co_fcn = co_fcn;

%set ode options, including event function
options = odeset('RelTol', 1e-3, 'AbsTol', 1e-3);

%solve equations of motion
soln = ode45(@genode, [0  P.time], P.initialc, options, P);


function qprime = genode(t, q, P)
%function qprime = genode(t, q, P)
%genode is a generic ode input/output function that returns values to ode45
%or a similar solver.
%
%input:
%q(2n + 1) represents q_(n-1)
%q(2n) represents q'_n
%
%output:
%qprime(2n + 1) represents q'_(n-1)
%qprime(2n) represents q''_n

[state whichleg] = P.co_fcn(P, q); %get state of constraint and which legs on

%calculate uncontstrained force and constrained force
unconstr_force = P.unconstrfce_fcn(P, q, whichleg);
constr_force = P.constrfce_fcn(P, q, whichleg,t);

%set up qprime vector
qprime = zeros(size(q));
%shift q' values into qprime(1:2:end)
qprime(1:2:end) = q(2:2:end);

if state %if constraint force is on
    %acceleration = inverse (mass matrix) * (total force)
    qprime(2:2:end) = P.massmtx(P, q)\(unconstr_force + constr_force); 
    
else %if constraint force is off
    %acceleration = inverse (mass matrix) * (total force)
    qprime(2:2:end) = P.massmtx(P, q)\(unconstr_force);
end

