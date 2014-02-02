function h = wire(x, y, z, varargin)

% function h = wire(x, y, z, <name/value pairs>)
% makes rigidbody wire through specified (x,y,z) points using cubic splines. 
% nb x must be increasing
% userdata field 'PP' contains the spline data structure PP (see help spline)
%                
% parameters
%     'name'        {'wire'}
%     'diameter'    {1}    
%     'segments'    {20}
%     'segmentby'   {'x'} | {'pathlength'} [rule for breaking wire into segments]
%     'segtol'      {1e-3}  [relative error tolerance in segment length]
%     'color'       {'m'}
%     'facealpha'   {1}
%
% nb segmentby pathlength is slow (computes a path integral per segment)
%
% Michael G Paulin August 2006


% x should be increasing 
% - but this allows (x,y,z) triples to be entered in any order
[x, indx] = sort(x);
y = y(indx);
z = z(indx);

% default parameters
% nb will get default radius after we find the total path length
bodyname = 'wire';
segments = 20;
segtol = 1e-3;
colour = 'm';
facealpha = 1;
segmentby = 'x';

% parameters from name/value pairs
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
                bodyname = value;
            case 'diameter'
                radius = value/2;
            case 'segments'
                segments = value;
            case 'segmentby'
                segmentby = value;
            case 'segtol'
                segtol = value;
            case {'color', 'colour'}
                colour = value;
            case 'facealpha'
                facealpha = value;
            otherwise  % fatal
                error(['unrecognized wire property (' name ')']);
                return

        end
    end
end

% spline data structure
PP = spline(x, [y(:) z(:)]');

% get x-values at segment boundaries 
switch segmentby
    
    case 'x'
        xseg = x(1) + (0:segments)*(x(end)-x(1))/segments;
        
    case 'pathlength'  % this takes much longer but gives nicer segmentation
        L = wirelength(PP, x(1), x(end));  % length of curve
        ds = L/segments;                     % segment length
        xseg = zeros(1, segments+1);
        xseg(1) = x(1);
        xseg(end) = x(end);
        for i=2:segments
            xseg(i) = splinestep(PP, xseg(1), (i-1)*ds, xseg(i-1)+ds, segtol);
        end
        
end

if ~exist('radius')
    radius = ds/4;                   % default segments are 2x as long as wide
end

% draw the wire
y = ppval(PP,xseg);  % y,z values at xseg
h = tube(xseg, y(1,:), y(2,:), radius);
set(h, 'facealpha', facealpha);
rigidbody(h, 'colour', colour, 'material', 'ether', 'type', 'surface');

% attach function handles 
uset(h, 'PP', PP);                     % piecewise polynomial spline definition

    



function s = wirelength(PP, x0,x1)

% function s = wirelength(PP, x0,x1)
% path length of cubic spline between x0 & x1
% 
% Michael G Paulin August 2006

if PP.dim==1
    ds = inline('sqrt(1+ppval(splinder(PP), x).^2)');       % line ds = sqrt(1+y'^2)dx
else
    ds = inline('sqrt(1+sum(ppval(splinder(PP), x).^2))');  % line ds = sqrt(1+y'^2+z'^2)dx etc in higher dims
end
f = @(x) ds(PP,x);     % use anonymous function to get handle of function of 1 variable
s = quadl(f, x0, x1);  % integrate it
