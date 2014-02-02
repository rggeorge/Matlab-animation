function J = mirtichmass(body, density)

% function J = mirtichmass(body, density [1])
% homogeneous mass matrix of a rigid body object
% from face-vertex data using mirtich algorithm
% nb 'givemass.m' computes this and inserts it in the inertia field
%
% Dyanimat toolbox
% (c) Michael G Paulin 2005

if nargin<2
    density=1;
end

% Mirtich algorithm
[volume,centerofmass,I] = volumeintegrate(body);
mass = density*volume;
    
% homogeneous inertia in center of mass frame
J = [ (diag([I(2,2)+I(3,3), I(1,1)+I(3,3), I(1,1)+I(2,2)])/2-I)+(1/2)*diag(diag(I)),  zeros(3,1); ...
    zeros(1,3), mass];
