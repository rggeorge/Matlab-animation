function varargout = rigidbody(h, varargin)

% function varargout = rigidbody(h, param/value pairs)
% make a rigidbody object from a handle graphics object
% params/values:
%    name         = {tag} | (unique name generated if no tag)
%    type         = {dummy} | body | surface | widget 
%    material     = {ether} | aluminium | steel | bone [& anything else defined in material.m]
%    colour       = {material colour} | existing facecolor
%    edgecolor    = {'none'} 
%    density      = {0}  [density of ether]
%    mass         = {computed by givemass.m}
%    centerofmass = {computed by givemass.m}
%    inertia      = {computed by givemass.m}  [ 3x3 standard inertia matrix ] 
%    frame        = {'world'} | 'body' | 'blunt' | 'point' | handle | pose  [see note]
%    axis         = {'x'} | 'y' | 'z'  direction of principle (long) axis
%                   
% nb: frame is the reference frame in which inertial properties are 
% computed, i.e. the rigid body's local reference frame.  The body's
% vertices are shifted into the specified frame, then the body is re-posed
% so that it remains in the same place in the world frame (MATLAB axes frame).  
% frame options: 
%    'body'   = local axes align with the body's principle axes of inertia,
%               with +x pointing along the long axis, towards the narrower
%               end of the body if there is one.
%    'blunt'  = 'body' axes moved so that the wider end of the body is at x=0.
%    'pointy' = ... narrower end of the body is at x=0.
%     handle  = handle of an object whose pose IN THE WORLD FRAME specifies the required frame
%     pose    = pose matrix specifying the required frame
%
% Dyanimat toolbox
% (c) Michael G Paulin 2004-2006

% defaults
% nb if h is already a rigidbody it inherits field values
%    uget() returns NaN if the field does not exist

% default rigidbody type is body
type = uget(h, 'type');
if isnan(type)  % no existing type
    type = 'body';
end

% % default inertia is none
% I = uget(h, 'inertia');
% if isnan(I)  % no existing inertia
%     I = zeros(4);
% end

%  4-inertia
J = uget(h, 'inertia');
if isnan(J)   % default for massless objects; will be over-ridden below if object has mass
    J = zeros(4);
end
I = [];  % 3-inertia not specified
mass = [];
centerofmass = [];

% default material is unspecified
mater = uget(h, 'material');
if isnan(mater)  % no existing material
    mater = 'unspecified';
end

% default parent (handle) is none
parent = uget(h, 'parent');
if isnan(parent)  % no existing parent
    parent = [];
end

% default child (handle) is none
children = uget(h, 'children');
if isnan(children)  % no existing children
    children = [];
else
    % disconnect children, keep a note of connection type
    cweld = zeros(numel(children),1);
    cdhlink = zeros(numel(children),1);
    for i=1:numel(children)
        if uget(children(i), 'weld')
            cweld(i)=1;
        end
        if uget(children(i), 'dhlink')
            cdhlink(i)=1;
        end
        disconnect(h, children(i));
    end
end

% default parent name is ''
parentname = uget(h, 'parentname');
if isnan(parentname)  % no existing parentname
    parentname = '';
end

% default child name is ''
childname = uget(h, 'childname');
if isnan(childname)  % no existing childname
    childname = '';
end

edgecolor = 'none';
ipose = eye(4);
iframe = [];
paxis = 'x';

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
            case 'type'
                type = value;
            case 'material'
                mater = value;
            case 'density'
                rho = value;
            case 'mass'
                mass = value;
            case 'centerofmass'
                centerofmass = value;
            case 'inertia'
                I = value;
            case 'frame'
                iframe = value;
            case 'axis'
                paxis = value;
            case {'colour', 'color'}
                colour = value;
            case 'edgecolor'
                edgecolor = value;
            otherwise  % fatal
                error(['unrecognized rigid body property (' name ')']);
                return

        end
    end
end

if ~exist('bodyname')
    bodyname = tag2varname(get(h, 'tag'));
end
if isempty(bodyname)
    bodyname = uniquename('rigidbody', 'rigidbody');
end



uset(h, 'rigidbody', true);
set(h, 'tag', bodyname);
uset(h, 'name', bodyname);
uset(h, 'type', type);
uset(h, 'material', mater);
% uset(h, 'inertia', I);
% uset(h, 'handle', h);
uset(h, 'parent', parent);
uset(h, 'parentname', parentname);
uset(h, 'childname', childname);
uset(h, 'children', children);
uset(h, 'dhlink', false);
uset(h, 'weld', 0);  % 1 if h is welded to its parent
uset(h, 'freeze', 0);
uset(h, 'pose', eye(4));
uset(h, 'sensor', []);
uset(h, 'istarget', 0);  % not the camera target

mater = material(mater);

% colouring
if ~isempty(mater.colour)
    set(h, 'facecolor', mater.colour);
end
if exist('colour')  % over-ride if colour is explicitly specified
  set(h, 'facecolor', colour);  
end

set(h, 'edgecolor', edgecolor);

% reference frame
if ischar(iframe)  % nb [] is not char
    switch iframe
        case 'world'
            ipose = eye(4);                                                  
        case 'body'
            ipose = inertiapose(h, 'alignaxis', paxis, 'alignbase', 'com');
        case 'blunt'
            ipose = inertiapose(h, 'alignaxis', paxis, 'alignbase', 'back');
        case 'pointy'
            ipose = inertiapose(h, 'alignaxis', paxis, 'alignbase', 'front');
    end
elseif numel(iframe)==1  % if a single number specified we assume it is an object handle
    ipose = pose(iframe, []);
end
% nb otherwise ipose is already a 4x4 pose matrix
            
% vertex data
V = get(h, 'vertices');         % row(i) = coords of ith vertex in world frame
V = [V  ones(size(V,1),1)];     % homogeneous coordinates in world frame
V = (inv(ipose)*V')';           % homogeneous coordinates in local frame

% shift vertices to new frame (nb body will move back before redraw)
set(h, 'vertices', V(:, 1:3));
% insert local frame vertex data into object userdata
uset(h, 'vertices', V);
uset(h, 'faces', get(h, 'faces'));

% mass properties 
if strcmp(type, 'body') | strcmp(type, 'link')
    
    % compute mass properties from face-vertex data
    [Jtmp, mass, centerofmass] = givemass(h, 'density', mater.density);  
    
    % use computed if didn't find existing J-matrix
    if ~trace(J)   % just a trick for checking whether J was set to zeros(4)
        J = Jtmp;
    end
    
    % over-ride existing inertia if 3-inertia was specified in call
    if ~isempty(I) 
        J = [I2J(I), mass*centerofmass(:); mass*centerofmass(:)', mass]; 
    end   
end
uset(h, 'inertia', J);


% now we have a rigidbody object, put it back where it should be
% (nb there has been no redraw, the object doesn't move in the world frame)
pose(h, ipose);


% reconnect children
for i=1:numel(children)
    if cweld(i)
        weld(h, children(i));
    end
    if cdhlink(i)
        dhlink(h, children(i));
    end
end

if nargout>0
    varargout{1} = h;
end
