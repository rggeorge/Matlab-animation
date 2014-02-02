function postq = rwaimpact_fcn(P,q)
%function postq = rwaimpact_fcn(P,q)
%
%rwaimpact calculates the post-impact angular velocity of the rimless wheel
%with properties set in P.  Used by rwa.m
%
%Ryan George
%COMO 401 Assignment One

beta = pi/P.nlegs; %half angle between one leg and next

posttheta = -(beta-P.alpha); %'reset' theta to be expressed in terms of next leg

%recalculate thetadot
postthetadot = q(2)*((P.centinertia +P.totalmass*(P.totalr^2)*cos(2*beta))/P.inertia);

postq = [posttheta; postthetadot];