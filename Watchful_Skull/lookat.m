function lookat(obj, target)
%function lookat(obj, target)
%lookat turns the z axis of obj so it intersects target.
%Ryan George
%COMO 401

%retrieve pose of target relative to the parent of object
targpose_re_objparent = pose(target, get_user_data(obj, 'parent'));

%direction from object's parent frame to target
primary_vector = targpose_re_objparent(1:3,4)/norm(targpose_re_objparent(1:3,4));

%find othonormal vectors to form basis for R3, so object is not deformed
[primary_vector second_vector third_vector] = findbasis3(primary_vector);

%retrieve object's pose so that we can leave it untranslated
former_obj_pose = pose(obj); 
%create new pose matrix, which will rotate the object's z-axis to intercept the target
new_pose = [second_vector third_vector primary_vector former_obj_pose(1:3,4); 0 0 0 1]; 
			
pose(obj, new_pose);