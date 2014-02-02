function repose(h)

% function repose(rigidbody)
% move vertices of link i so that frame (i) aligns with 
% the frame of the parent of link i, 
% and adjust inertia properties accordingly. 
%
% e.g. if you want frame(i) to be at the center of mass of link i then
% move the center of mass to the parent origin and repose.  You would
% normally do this when link i is created & its parent is the world, 
% before posing it and connecting it into the linkage.
%
% MGP July 2004/October 2005


% reset child pose in parent frame
uset(h, 'pose', eye(4));
P = pose(parent(h));
V = get(h, 'vertices')';            % h's vertices in world frame
nvertex = length(V);
V = inv(P)*[V ; ones(1, nvertex)];  % h's vertices in parent frame 
uset(h, 'vertices', V');       


% P = pose(h);
% uset(h, 'vertices', (P*uget(h, 'vertices')')');
% uset(h, 'pose', eye(4));

% child = uget(h, 'children');
% for i=1:length(child)
%  uset(child(i), 'pose', P*uget(child(i), 'pose'));
% end