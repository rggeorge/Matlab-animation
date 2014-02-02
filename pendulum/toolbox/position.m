function r = position(h, p, g)

% function r = position(h, p, g)
% set/get position of rigidbody wrt g
% without altering orientation
% 
% r = position(h)     position of h wrt its parent
% r = position(h,g)   ... wrt g
% r = position(P)     position from pose matrix P
% position(h,p,g)     moves h to position (3-vector) p 
%                        wrt g (default = parent(h)
% 
% Dyanimat toolbox
% (c) Michael G Paulin 2005

if nargin==1
    if numel(h)==1 % return pose of h wrt parent
        r = pose(h);
        r = r(1:3,4);
    else           % extract position from pose matrix
        r = h(1:3, 4);
    end
else
    if numel(p)<=1  % p is a handle, return position of h wrt p
        r = pose(h,p);
        r = r(1:3,4);
    else            % p is a position vector, position wrt parent
        if nargin<3
            g=parent(h);
        end
        pose(h, r4(r3(pose(h, g)), p), g);
    end
end