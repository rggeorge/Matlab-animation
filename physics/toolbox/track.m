function g = track(varargin)

% function g = track(<propname, propvalue>)
% ground plane object with ground reaction and drag-friction forces
% implemented using damped nonlinear springs
% has handles for functions 
%    z = zfcn(x,y)           % ground height (z) at world (x,y)
%    u = normalvector(x,y)   % unit normal 3-vector at (x,y,z)
%    Qn = nforce(h,g,t,x,p)  % normal ground reaction force acting on 
%                              rigidbody h in state x at time t
%    Qt = tforce(h,g,t,x,p) % tangential ground drag-friction force acting
%                              on h in state x at time t
% 
% properties and default values
%    name            'track'
%    xlim            [-10 100]
%    ylim            [-20 20]
%    gridsize        [10 10]
%    xslope          0
%    yslope          0
%    zintercept      0
%    material        {'track'} 'grass' 'concrete' 'mud' 'ice'
%    facealpha       [.25]
%    gridcolor       ['k']
%
% different track materials have different stiffness, damping and friction.
% The default track is a resiliant running track with high friction
% for further details and to define new track materials see function
% 'trackmaterial'
% 
% Dyanimat toolbox
% (c) Michael G Paulin 2007

name       = 'track';
xlim       = [-10 100];
ylim       = [-20 20];
gridsize   = [10 10];
xslope     = 0;
yslope     = 0;
zintercept = 0;
facealpha  = .25;
gridcolor  = [0 0 0];
ptrack = trackmaterial('track');


N = length(varargin);
for i=1:N/2
    switch lower(varargin{i*2-1})
        case 'name'
            name = varargin{2*i};
        case 'xlim'
            xlim  = varargin{2*i};
        case 'ylim'
            ylim = varargin{2*i};
        case 'gridsize'
            gridsize = varargin{2*i};
        case 'xslope'
            xslope = varargin{2*i};
        case 'yslope'
            yslope = varargin{2*i};
        case 'zintercept'
            zintercept = varargin{2*i};
        case 'material'
            ptrack = trackmaterial(varargin{2*i});
        case 'facealpha'
            facealpha = varargin{2*i};
        case {'gridcolor', 'gridcolour'}
            gridcolour = varargin{2*i};
    end
end

x = [xlim(1):gridsize(1):xlim(2)];
y = [ylim(1):gridsize(2):ylim(2)];
s = surf(x, y, zeros(numel(y), numel(x)));
g = patch(surf2patch(s));
delete(s);
rigidbody(g, 'name', name, 'type', 'surface');

set(g, 'facecolor', ptrack.color, 'facealpha', facealpha, 'edgecolor', gridcolor);
pose(g, [atan(xslope) pi/2 atan(yslope)]); 
repose(g);
pose(g, r4([0 -pi/2 0], [0 0 zintercept]));
repose(g)

gdata = uget(g);
gdata.zfcn            = @(x,y) zintercept+xslope*x+yslope*y;
gdata.normalvector    = @(x,y) [-xslope -yslope 1]'/sqrt(1+xslope^2+yslope^2);
gdata.type            = 'ground';
gdata.handle          = g;
gdata.nforce          = @nforce
gdata.tforce          = @tforce;

uset(g, gdata);

function Fn = nforce(h, g, t, x, p)
disp('hello from nforce')

function Tn = tforce(h, g, t, x, p)
disp('hello from tforce')
