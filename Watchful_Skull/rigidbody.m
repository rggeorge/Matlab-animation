function rigidbody(obj, name)
%function rigidbody(obj, name)
%rigidbody makes 'obj' a rigid body.  It resets the object's
%parent field, child field, pose, and vertices.  If 'name' is
%given, the object is tagged with that name in its user data.
%Ryan George
%COMO 401

pre_vertices = get(obj, 'vertices');

%change format of vertices; add a fourth row of ones 
%for multiplication by pose matrices
u.vertices = [pre_vertices'; ones(1,size(pre_vertices,1))];
u.parent = [];
u.child = [];
u.pose = eye(4);

if nargin >1 %rigidbody(h, name)
    u.name = name; %set object's name as given
else
    u.name = get(obj, 'tag'); %set object's name as its tag
end

set_user_data(obj, u);
end