function rigidbody(obj, name)

pre_vertices = get(obj, 'vertices');
u.vertices = [pre_vertices'; ones(1,size(pre_vertices,1))];
u.parent = [];
u.child = [];
u.pose = eye(4);

if nargin >1
    u.name = name;
else
    u.name = get(obj, 'tag');
end

set_user_data(obj, u);
end