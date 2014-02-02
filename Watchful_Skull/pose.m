function pose_output = pose(obj, arg2, arg3)
% function pose_output = pose(obj, arg2, arg3)
% pose performs the following functions:
% pose(h) - returns pose of h in its parent frame
% pose(h,[]) returns pose of h in world frame
% pose(h,g) returns pose of h relative to g
% pose(h,P) poses h with pose matrix P relative to h's parent
% pose(h,P,g) poses h with pose matrix relative to g
% The last two modes pose all children of the object recursively
%Ryan George
%COMO401

parent = get_user_data(obj,'parent'); % get parent

if numel(obj) < 1  % object is the world (i.e. [] )
        pose_output = eye(4);
elseif nargin < 2 % pose(h)
    pose_output = get_user_data(obj, 'pose'); %pose in parent frame
    
elseif numel(arg2)< 2 % pose(h,g)

	% get pose of obj in the world frame
    obj_pose_0 = pose(parent,[])*get_user_data(obj, 'pose');
	% get pose of arg2 (g) in world frame
    arg2_pose_0 = pose(arg2,[]);
	% pose composition gives pose of h relative to g
    pose_output = arg2_pose_0\obj_pose_0;  
    
else % contains options for repositioning objects
    vertices = get_user_data(obj, 'vertices');
    parent_pose = pose(parent, []);
    
    if nargin == 2 %pose(h,P)
        set_user_data(obj, 'pose', arg2);
        pose_mat_rel2world = parent_pose*arg2;
        
    else %pose(h,P,g)
        %use pose composition to get pose of obj relative to parent:
        %P_ph-h == P_ph-0 * P_0-g * P_g-h 
        %(P_ph-h is the pose of h relative to the parent of h)
        pose_rel_to_parent =(parent_pose\pose(arg3, []))*arg2;
        set_user_data(obj, 'pose', pose_rel_to_parent);
        pose_mat_rel2world = parent_pose*pose_rel_to_parent;
    end
    
	%multiply vertices by pose matrix, change position!
    new_vertices = pose_mat_rel2world*vertices;
    set(obj, 'vertices', new_vertices(1:3,:)');
	%no output
    
    %recursively reposition all children (and their children) according 
    %to their current pose ONLY IF we moved the object
    child = get_user_data(obj, 'child');
    for n = 1:numel(child)
        pose(child(n), get_user_data(child(n), 'pose'));
    end

end

end
