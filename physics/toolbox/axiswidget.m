function a = axiswidget(varargin)

% function a = axiswidget(propname/propvalue)
% function awidget = axiswidget(name, axlength, discalpha, axisalpha,
% radius)
% for visualizing pose
% properties  & default values:
%          name = uniquename('axiswidget_');
%          size = 1
%     discalpha = .25
%    arrowalpha = 1
%       npoints = 16
% draws xyz coordinate axes with circular ground (xy) plane
% Pose is 4x4 pose matrix
% size is axis length default 1
% radius is radius of axis cylinders (default 0.025*size);
% patchalpha and axisalpha (0<alpha<1) are rendering transparencies 
% (not drawn if alpha = 0)
% a is handle of the x-arrow, other components are welded to it
% (c) Michael G Paulin 2003-05


% default parameter values
name = uniquename('axiswidget_');
L = 1;
discalpha = .25;
arrowalpha = 1;
npoints = 16;

% specified parameter values
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
                stickname = value;
            case 'size'
                L = value;
            case 'discalpha'
                discalpha = value;
            case 'axisalpha'
                axisalpha = value;
            case 'npoints'
                npoints = value;
            otherwise  % fatal
                error(['unrecognized stick property (' name ')']);
                return
        end
    end
end

radius = .075*L; 
head = 6*radius;

xax = arrowidget('length', L+head, 'radius', radius, 'colour', 'r', 'npoints', npoints, 'name', name, 'type', 'axiswidget');
% uset(xax, 'name', name);
nxa = tube([-L 0], [0 0], [0 0], radius/2, 'NPoints', npoints);
rigidbody(nxa, 'name', [name '_nxa'], 'type', 'widget', 'colour', 'r');
weld(xax, nxa);

yax = arrowidget('length', L+head, 'radius', radius, 'colour', 'g', 'npoints', npoints, 'name',[name '_yax'] );
pose(yax, [0 pi/2 0]);
weld(xax, yax);
nya = tube(  [0 0], [-L 0], [0 0],radius/2,'NPoints', npoints);
rigidbody(nya, 'name', [name '_nya'], 'type', 'widget', 'colour', 'g');
weld(xax, nya);

zax = arrowidget('length', L+head, 'radius', radius, 'colour', 'b', 'npoints', npoints, 'name', [name '_zax']);
pose(zax, [pi/2 pi/2 0]);
weld(xax, zax);
nza = tube( [-L 0], [0 0],[0 0], radius/2, 'NPoints', npoints);
rigidbody(nza, 'name', [name '_nza'], 'type', 'widget', 'colour', 'b');
pose(nza, [pi/2 pi/2 0]);
weld(xax, nza);

% get cylinder coordinates
N=4*npoints;
ang = (0:N)'*2*pi/N;

% draw disc in xy plane 
if discalpha>0
    discvertex = [L*cos(ang), L*sin(ang), zeros(N+1,1), ones(N+1,1)];
    discface   = 1:(N+1);
    disc = patch('vertices', discvertex(:, 1:3), 'faces', discface, 'facecolor', [0 0 0], 'facealpha', discalpha);
    rigidbody(disc,'name', [name '_disc'], 'type', 'widget');
    weld(xax, disc);
else 
    disc = [];
end

hold on

a = xax;  % parent object
% c = uget(awidget, 'children');
% for i=1:length(c)
%     uset(c(i), 'type', 'partofaxiswidget');
% end




