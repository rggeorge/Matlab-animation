%function assign_child(parent, child)
%assign_child adds 'child' to the parent's children, and changes the
%child's parent to the first argument.  The child's vertices are
%re-calculated in the parent frame, and its pose is set to the identity
%matrix.  This means that when assign_child is run, the child must be at
%the origin in the parent frame.

function assign_child(parent, child)

former_child = get_user_data(parent, 'child');
new_child = [former_child   child];
set_user_data(parent, 'child', new_child);

set_user_data(child, 'parent', parent);
set_user_data(child, 'pose', eye(4));
parent_pose_rel2world = pose(parent);
old_vertices = [get(child, 'vertices')'; ones(1,size(get(child, 'vertices'), 1))];
new_vertices = inv(parent_pose_rel2world)*old_vertices;
set_user_data(child, 'vertices', new_vertices);