function lookat(h)

% function lookat(h)
% h is either a rigidbody object or an x,y,z position
% set cameratarget to origin of h frame
% if the target is a rigidbody, tag its userdata
% MGP Oct 2004

% remove existing target
bod = findbody;
for i=1:numel(bod)
    uset(bod(i), 'istarget', 0);
end

if numel(h)==3
    set(gca, 'cameratarget', h)
else
    set(gca, 'cameratarget', position(pose(h, [])));
    uset(h, 'istarget', 1);
end