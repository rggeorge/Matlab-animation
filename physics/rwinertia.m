function [inertia_about_foot inertia_about_center] = rwinertia(P)
%function [inertia_about_foot inertia_about_center] = rwinertia(P)
%
%rwinertia calculates the moment of inertia of the rimless wheel specified
%by parameters in P.
%'inertia_about_foot' refers the moment of inertia of the wheel about the
%tip of one of its feet; 'inertia_about_center' "" about the center of the
%wheel
%
%Ryan George
%COMO 401, Assignment 2

%inertia of disc about center
discinertia = P.discmass*(P.discr^2)/2;

%inetia of one leg about center of mass (perpendicular to length)
leginertia = P.legmass*(3*P.legr^2 + (P.legl-P.conel)^2)/12;

%inertia of one cone about tip
coneinertia_about_tip = (3/5)*P.conemass*((P.legr^2)/4 + P.conel^2);

%inertia of cone about center of mass
coneinertia_about_cm = coneinertia_about_tip - P.conemass*((P.conel*.75)^2);

%distance with which to 
dist2move_leginertia = P.discr + (P.legl-P.conel)/2;
dist2move_coneinertia = P.discr + P.legl + P.conel*.25;

%use parallel axis theorem to calculate moment of inertia about center of wheel
inertia_about_center = discinertia + ...
    P.nlegs*( (leginertia + P.legmass * dist2move_leginertia^2) +...
            (coneinertia_about_cm + P.conemass * dist2move_coneinertia^2));

%use parallel axis theorme to calculate moment of inertia about tip of foot
inertia_about_foot = inertia_about_center + P.totalmass * P.totalr^2;