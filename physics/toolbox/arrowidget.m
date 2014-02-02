function v = arrowidget(varargin)

% function v = arrowidget(propnames/propvalues)
% makes a solid arrow rigidbody pointing along the x-axis
% properties:
%           name = 'arrow', 
%         length = 1, 
%     headlength = 6*radius;
%         colour = red, 
%         radius = .02*vectorlength, 
%        npoints = 16 (# points on circumference)
%           type = 'arrowwidget' (sometimes you want an arrowidget to be an axiswidget)
%
% (c) Michael G Paulin 2005


name = 'arrow';
L = 1;
radius = -99;
headL = -99;
colour = 'r';
npoints = 16;
widget_type = 'arrowwidget';

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
                arrowname = value;
            case 'length'
                L = value;
            case 'headlength'
                headL = value;
            case 'radius'
                radius = value;
            case 'npoints'
                npoints = value;
            case {'colour', 'color'}
                colour = value;
            case 'type'   
                widget_type = value;
            otherwise  % fatal
                error(['unrecognized stick property (' name ')']);
                return
        end
    end
end

% defaults
if radius<0
    radius = 0.02*L;
end
if headL<0
    headL = 6*radius;
end

% create vector along the x-axis
x = [ (0:10)*(L-headL)/10 L-.99*headL L]';
r = [ones(1,11)*radius                 radius*2                         0           ];
v = tube(x, zeros(size(x)),  zeros(size(x)), r, 'NPoints', npoints);
% set(v, 'edgecolor', 'none', 'facecolor', colour);
rigidbody(v, 'name', name, 'type', widget_type, 'colour', colour);
