function constr_force = rwbconstr_fce(P,q, whichleg,t)
% dpuf calculates the constraint force for the compound pendulum
% animated by animatedp. This force represents the string tension that
% pulls on mass1 when the string is fully stretched out.
% Inputs are data structure P, state variables q, which legs are on the ground.
%
% Ryan George
% COMO 401, Assignment Two

al = P.alpha; %angle of ground
r = P.totalr; %total wheel radius

M = P.mass_mtx; %mass matrix
F = rwbuncstr_fce(P,q, whichleg); %unconstrained force

%adjust theta to be expressed in terms of the leg that constraint force
%will be acting on
th = q(5) + (front(whichleg)-1)*2*pi/P.nlegs; 

%LHS of matrix constraint equation  A(q'') = b
A = [cos(al)  -sin(al)  -r*(cos(th)*cos(al)+sin(th)*sin(al))];

%RHS of equation A(q'') == b
b = -r*(q(6)^2)*(sin(th)*cos(al)-cos(th)*sin(al));

%in case numel(whichleg) > 2 and dimension of A do not permit calculation
try
    %calculate constraint force
    constr_force = sqrtm(M)*pinv(A/(sqrtm(M)))*(b-A*(M\F));
catch
    %let constraint force be zero
    constr_force = zeros(3,1);
end