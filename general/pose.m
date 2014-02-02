function pose_output = pose(obj, pose_mat)

%function pose_output = pose(obj, pose_mat)
%pose.m has two functions. If only an object is input, pose will return
%that object's pose in the parent frame.  If an object and a pose matrix is
%input, pose will move that object to that pose, and its children
%accordingly


parent = get_user_data(obj,'parent');

if nargin < 2
    if numel(obj) < 1
        pose_output = eye(4);
    else
        %if strcmp(get_user_data(obj, 'jointype'), 'w')
        %    pose_output = eye(4);
        %else
        pose_output = pose(parent)*get_user_data(obj, 'pose');
        %end
    end
else
    vertices = get_user_data(obj, 'vertices');
    set_user_data(obj, 'pose', pose_mat)
    pose_mat_rel2world = pose(parent)*pose_mat;
    new_vertices = pose_mat_rel2world*vertices;
    set(obj, 'vertices', new_vertices(1:3,:)');
    pose_output = pose_mat_rel2world;

%reposition all children (and their children) according to their former pose
child = get_user_data(obj, 'child');
for n = 1:numel(child)
    pose(child(n), get_user_data(child(n), 'pose'));
end

end