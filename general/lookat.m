function lookat(obj, target_coords)

%function lookat(obj, target_coords)
%lookat turns the z-axis of obj so it intersects target_coords
%Example:
%function lookat(RightI, [1 1 1])

% target_pose = eye(4);
% target_pose(1:3,4) = target_coords(:)';
% 
% target_pose_in_obj_axis = inv(pose(obj))*target_pose;
% 
% z_vector = target_pose_in_obj_axis(1:3,4) ...
%           /norm(target_pose_in_obj_axis(1:3,4).^2);

obj_pose_0 = pose(obj);
z_vector = target_coords(:) - obj_pose_0(1:3,4);
z_vector = z_vector/norm(z_vector);

y_vector = [1 0 0]';
y_vector(3) = (-z_vector(1)*y_vector(1)-z_vector(2)*y_vector(2))/z_vector(3);
if norm(y_vector) == 0  % in case the target coords are in the line of [1 0 0]'
    y_vector = [0 1 0]';
    y_vector(3) = (-z_vector(1)*y_vector(1)-z_vector(2)*y_vector(2))/z_vector(3);
end
y_vector = y_vector/norm(y_vector.^2);
      
x_vector = cross(y_vector, z_vector);

former_obj_pose = get_user_data(obj, 'pose');
new_pose = [z_vector y_vector x_vector former_obj_pose(1:3,4); 0 0 0 1];
pose(obj, new_pose);