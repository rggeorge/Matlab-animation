function v = vector(a,b, varargin)

% function v = vector(a,b, <name/value pairs>)
% rigidbody vector (3d arrow) from a to b 
% optional paramters
%           name = {'vector'}, 
%     headlength = {6*radius};
%         colour = {'r'}, 
%         radius = {.02*length}, 
%        npoints = {16} [# points on circumference]
%
% Michael G Paulin September 2006

vectorname = 'vector';
vectorlength = norm(b-a);
headlength = 0;
radius = 0;
colour = 'r';
npoints = 16;
widget_type = 'vector';

N = length(varargin);
for i=1:2:N  % extract name-value pairs
    name  = varargin{i};
    value = varargin{i+1};
    if ~ischar(name) % fatal
        error('properties must be specified as property name/value pairs');
        return
    else
        switch name
            case 'name'
                vectorname = value;
            case 'headlength'
                headlength = value;
            case 'radius'
                radius = value;
            case 'npoints'
                npoints = value;
            case {'colour', 'color'}
                colour = value;
            otherwise  % fatal
                error(['unrecognized stick property (' name ')']);
                return
        end
    end
end
if ~radius
    radius = 0.02*vectorlength;
end
if ~headlength
    headlength = 6*radius;
end

 R = point2([1 0 0], b-a);  % rotation vector, x-axis -> vector direction
 
 v = arrowidget('length', vectorlength, 'radius', radius, ...
                'headlength', headlength, 'npoints', npoints, ...
                'color', colour, 'name', vectorname);
            
 pose(v, [R a(:); 0 0 0 1]);
 
 
 
 
 
 
 
 
 
 
 
 
 