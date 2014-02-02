function [stick,J, I] = pointystick(varargin)

% function stick = pointystick( <property name/value pairs>)
% make cylindrical rigidbody object with conical caps at each end
%
% property names and default values:
%
%    name          {auto}
%    length        1
%    bottom        .001*length
%    top           .001*length
%    radius        .1*length   % radius at base of top cap
%    radius2       radius      % radius at base of bottom cap
%    zstretch      1  % flatten (<1) or stretch (>1) in z-direction        
%    material      'unspecified'
%    density       1
%    center        1
%    axiswidget    0
%    axis          'x'
%    npoints       32
%    color         'r'
%
%    note: (1) length includes caps.
%          (2) center is +1 for link frame at top end (default)
%                         0 for link frame at center of mass 
%                        -1 for link frame at bottom end
%          (3) axiswidget parameter is length of axiswidget at link frame
%              origin (default = no axiswidget)
%          (4) axis is 'x', 'y' or 'z'
%          (5) npoints is the number of points around the circumference.
%              e.g. the stick can be triangular or square in x-section.
%
% MGP Aug/Oct 2005

% default parameters
zstretch = 1;

% interpret parameter list
if ~iseven(length(varargin))  % fatal
    error('stick properties must be specified as property name/value pairs');
    return
end

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
            case 'length'
                L = value;
            case 'bottom'
                c1 = value;  % 'height' of bottom cone
            case 'top'
                c2 = value;  % 'height' of top cone
            case 'radius'
                r = value;
            case 'radius2'
                r2 = value;
            case 'zstretch'
                zstretch = value;
            case 'material'
                materialname = value;
            case 'density'
                rho = value;
            case {'center', 'centre'}
                center = value;
            case 'axiswidget'
                axwlength = value;
            case 'axis'
                stickaxis = value;
            case 'npoints'
                npts = value;
            case {'colour', 'color'}
                colourspec = value;
            otherwise  % fatal
                error(['unrecognized stick property (' name ')']);
                return

        end
    end
end

% default parameter values
if ~exist('stickname')
    stickname = ['pointy stick'];
end
if ~exist('L')
    L = 1;
end
if ~exist('c1')
    c1 = 0;
end
if ~exist('c2')
    c2 = 0;
end
if ~exist('r')
    r = .1*L;
end
if ~exist('r2')
    r2 = r;
end
if exist('materialname')
    mater = material(materialname);
    rho = mater.density;
    colour = mater.colour;
else
    materialname = 'unspecified';
end
if ~exist('rho')
    rho = 1;
end
if ~exist('center')
    center = 1;
end
if ~exist('axwlength')
    axwlength = [];
end
if ~exist('stickaxis')
    stickaxis = 'x';
end
if ~exist('npts')
    npts = 32;
end
if exist('colourspec')  % specified colour over-rides material colour
    colour = colourspec;
end
if ~exist('colour')
    colour = [1 0 0];
end

if (c2+c1)>=L
    error('Sum of cone lengths must be less than stick length');
    return
end

if any([c1 c2 L]<0)
    error('lengths must be >=0');
    return
end
    

% draw stick as circular tube with the tip of the top cone at the origin
% nb this places the local reference frame for DH convention
if c1==0
    if c2==0  % flat both ends
        stick = tube([-L  0], zeros(1,2),  zeros(1,2), [r2 r], 'closed', true, 'NPoints',npts);
    else      % flat at left
        stick = tube([-L (-L-c2)/2 -c2 0], zeros(1,4),  zeros(1,4), [r2 r2  r  0], 'leftclosed', true, 'NPoints',npts);
    end
elseif c2==0  % flat at right
    stick = tube([-L (-L+c1) (c1-L)/2 0], zeros(1,4),  zeros(1,4), [0 r2 r  r], 'rightclosed', true, 'NPoints',npts);
else          % cone both ends
    stick = tube([-L (-L+c1) -c2 0], zeros(1,4),  zeros(1,4), [0 r2  r  0], 'NPoints',npts);
end

% ... squish/stretch in z direction
set(stick, 'vertices', get(stick, 'vertices')*diag([1 1 zstretch]));

% mass of each component
mass_top = zstretch*rho*pi*r^2*c2/3;
mass_bot = zstretch*rho*pi*r^2*c1/3;
mass_rod = zstretch*rho*pi*r^2*(L-c1-c2);

% center of mass of each component
com_top = [-(3/4)*c2, 0, 0];
com_bot = [-L+(3/4)*c1, 0, 0];
com_rod = [(-L+c1-c2)/2, 0, 0];

% moments of inertia for each component around its centre of mass
Icom_top_xx = (3/20)*mass_top*r^2*(1+zstretch^2);
Icom_top_yy = (3/80)*mass_top*c2^2 + (3/20)*mass_top*r^2;
Icom_top_zz = Icom_top_yy;

Icom_bot_xx = (3/10)*mass_bot*r^2*(1+zstretch^2);
Icom_bot_yy = (3/80)*mass_bot*c1^2 + (3/20)*mass_top*r^2;
Icom_bot_zz = Icom_bot_yy;

Icom_rod_xx = (1/4)*mass_rod*r^2*(1+zstretch^2);
Icom_rod_yy = (1/12)*mass_rod*(L-c1-c2)^2 + (1/4)*mass_rod*r^2;
Icom_rod_zz = Icom_rod_yy;

% pointystick moments of inertia (from parallel axis theorem)
Ixx = Icom_bot_xx + Icom_rod_xx + Icom_top_xx;
Iyy = Icom_bot_yy + Icom_rod_yy + Icom_top_yy + ...
      mass_bot*com_bot(1)^2 + mass_rod*com_rod(1)^2 + mass_top*com_top(1)^2;    
Izz = Iyy;

% mass and center of mass
mass = mass_bot + mass_rod + mass_top;
centerofmass =  [(mass_bot*com_bot(1) + mass_rod*com_rod(1) + mass_top*com_top(1))/mass 0 0];

% mass = (1/3)*rho*(3*L-2*(c1+c2))*pi*r^2;
% centerofmass = [(3*c1^2-3*c2^2-8*c1*L+6*L.^2)/(8*(c1+c2)-12*L),0,0];
% Izz = (-1/60)*rho*pi*r^2*(8*(c1^3+c2^3) -30*c1^2*L+40*c1*L^2 -20*L^3+3*(4*(c1+c2)-5*L)*r^2);
% Ixx = (1/10)*rho*(6*c1-4*c2+5*L)*pi*r^4;

I = diag([Ixx, Izz, Izz]);  % standard 3x3 inertia matrix re current frame origin

% make it a rigid body object
rigidbody(stick, 'name', stickname, 'material', materialname, 'mass', mass, 'centerofmass', centerofmass,'inertia', I, 'type', 'body');

J = uget(stick, 'inertia');

% shift to required origin 
if center==-1
    position(stick, [L 0 0]);
    T = pose(stick);  % new pose
    J = T*J*T';       % find homogeneous inertia in the new pose
    repose(stick);    % shift vertex data  
end
if center==0
    position(stick, -centerofmass);
    T = pose(stick);  % new pose
    J = T*J*T';   % find homogeneous inertia in the new pose
    repose(stick);    % make this the q=0 pose
end
if stickaxis=='z'
    pose(stick, [pi/2, pi/2, 0]);
    T = pose(stick);  % new pose
    J = T*J*T';       % homogeneous inertia in new pose
    repose(stick);    % make this the q=0 pose
end
if stickaxis=='y'
    pose(stick, [0, pi/2, 0]);
    T = pose(stick);  % new pose
    J = T*J*T';       % homogeneous inertia in new pose
    repose(stick);    % make this the q=0 pose
end

% axis widget at link origin if requested
if ~isempty(axwlength)
    a = axiswidget([stickname 'axiswidget'], axwlength);
    pose(a, pose(stick));
    weld(stick,a);
end

set(stick, 'edgecolor', 'none', 'facecolor', colour);

% mass properties
uset(stick, 'inertia', J);
% nominal inertia backed up in case overwritten by givemass
uset(stick, 'specifiedinertia', J);

% no sensors
uset(stick, 'groundsensor', []);

% set(stick, 'buttondownfcn', 'dyannotate(gco)');
