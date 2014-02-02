function varargout = givemass(h, varargin)

% function [J, mass, centerofmass, I]  = givemass(h, <masspropertypairs>)
% compute & set mass/inertia properties of a rigidbody object in the world
% frame using Mirtich algorithm
%
% mass properties and [default] values are:
%           
%   'density'       [1]
%
%         
% Dyanimat Toolbox (c) Michael G Paulin 2005-2006

if ~iseven(length(varargin))  % fatal
    error('mass properties must be specified as property name/value pairs');
    return
end

% defaults
density = 1;

N = length(varargin);
for i=1:2:N/2  % extract name-value pairs
    name  = varargin{i};
    value = varargin{i+1};
    if ~ischar(name) | ~isnumeric(value)  % fatal
        error('mass properties must be specified as property name/value pairs');
        return
    else
        switch name
            case 'density'
                density = value;
            otherwise  % fatal
                error(['unrecognized mass property (' name ')']);
                return

        end
    end
end

% calculate mass properties using Mirtich algorithm
[volume,centerofmass,I] = volumeintegrate(h);
    
mass=volume*density;
I = I*density;

% homogeneous inertia in center of mass frame
J = [ I2J(I) zeros(3,1); zeros(1,3) mass];

% homogeneous inertia in local frame 
% (i.e. the frame in which vertices of h are specified)
T = [eye(3) centerofmass(:); zeros(1,3) 1];  % origin -> center of mass transformation
J = T*J*T';

% set inertia property of object 
uset(h, 'inertia', J);

% return mass properties
varargout{1}=J;
varargout{2}=mass;
varargout{3}=centerofmass;
varargout{4}=I;


