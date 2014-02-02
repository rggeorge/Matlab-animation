function assign_child(parent, child)
%function assign_child(parent, child)
%Assigns parent to child, child to parent.  The child's pose is set to the
%identity matrix, and its vertices are computed relative to its parent
%frame
%Ryan George 2009
%COMO 401

%put child in parent's list of children
former_child = get_user_data(parent, 'child');
new_child = [former_child   child];
set_user_data(parent, 'child', new_child);

%change child's parent, reset pose, recalculate vertices to be in parent frame
set_user_data(child, 'parent', parent);
set_user_data(child, 'pose', eye(4));
parent_pose_rel2world = pose(parent, []);
old_vertices = [get(child, 'vertices')'; ones(1,size(get(child, 'vertices'), 1))];
new_vertices = inv(parent_pose_rel2world)*old_vertices;
set_user_data(child, 'vertices', new_vertices);