function P = inertiapose(h, varargin)

% function P = inertiapose(h, name/value pairs)
% Pose corresponding to principle axes of inertia of a patch object 
%
% optional args:
%   'alignaxis'  'x'  | 'y' | {'z'}
%                [which pose frame axis is aligned with the axis having the
%                 smallest rotational inertia]
%   'alignbase'  {'front'} |  'back' | 'com'
%                [pose origin can be at the front (pointy end), back 
%                 (blunt end) or centre of mass of the object; default is
%                 the front end].
%
% This function is intended for locating joints in 3D scenes using conical
%    pointers.  The default behaviour is: If h is the handle of a conical
%    object, then P is the pose of a frame whose origin is at the tip of the
%    cone and whose z-axis points along the cone's axis.  More generally, you 
%    can use it to attach 'natural' local coordinate frames to arbitrary
%    objects, ie. frames that line up with the object's principle axes of 
%    inertia.  
% Function 'jointaxis' is an alias for 'inertiapose' (easier to remember in
%    the specific context of specifying joint axes. 
% Note that the function works by finding the principle inertia
%    axes and assuming that the pointy bit is the end of the object furtherest 
%    from the center of mass in the direction of the principle (minimum inertia) axis. 
%    So your pointer does not have to be a cone but it does have to be pointy, 
%    i.e. with an obvious long axis & narrower at one end. Make sure e.g. that 
%    a conical pointer is longer/taller than the diameter of its base.  
%
% (c) Michael G Paulin Feb 2006


N = length(varargin);
for i=1:N/2
    switch lower(varargin{i*2-1})
        case 'alignaxis'
            iax = find('xyz'==lower(varargin{2*i})); % 'x'->1, 'y'->2, 'z'->3
        case 'alignbase'
            alignbase  = varargin{2*i};
    end
end

% defaults
if ~exist('iax')
    iax = 3;
end
if ~exist('alignbase')
    alignbase = 'front';
end


% volume, center of mass and inertia tensor
[vol, com, I] = volumeintegrate(h);

% eigenvectors & eigenvalues of inertia tensor
[evec, evalue] = eig(I);  

% index of the smallest eigenvalue 
% is the index of the axis with the smallest inertia 
% is the major axis of the equivalent ellipsoid 
% i.e. the long axis of the object
evalue = diag(evalue)';
is = find(evalue==min(evalue)); is=is(1); % just in case has >1 equal smallest evals

% shift eigenvectors so that the column corresponding to the major (min
% inertia) axis corresponds to the axis of the pose frame that we want 
% pointing in that direction.
evec=circshift(evec, [ 0 iax-is]);   

% we want the z-axis to point towards the 'pointy end' of the object,
% which we take to be the end furtherest from the centre of mass along the z-axis
v = get(h, 'vertices');
[m,n] = size(v);
d = (v-ones(m,1)*com(:)')*evec(:,iax); % vertex distances from c.o.m along designated axis
if -min(d)>max(d)  % if the object extends further in - direction than in + direction
    evec(:,iax) = -evec(:,iax); % reverse the axis
    d=-d;
end

% pose might be left-handed at this point (bad).
if det(evec)<0
    oax = mod(iax,3)+1;          % pick the next axis, cyclic
    evec(:,oax) = -evec(:,oax);  % reflect the axis to give rh frame
end

% build pose matrix
origin = com;
switch alignbase
    case 'back'
        offset = min(d);
    case 'com'
        offset = 0;
    otherwise
        offset = max(d);
end
origin = origin+offset*evec(:,iax);
P = [evec origin(:); 0 0 0 1];




