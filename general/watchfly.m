try
rays = 1; %ray option
lr = line([0 0], [0 0], [0 0]); ll= line([0 0], [0 0], [0 0]);
% if rays = 1
%    lr = line([RE_cent(1) obj_pos(1)], [RE_cent(2) obj_pos(2)],...
%             [RE_cent(3) obj_pos(3)]);
%    ll = line([LE_cent(1) obj_pos(1)], [LE_cent(2) obj_pos(2)],...
%             [LE_cent(3) obj_pos(3)]);
% end
pose(Skull, eye(4));
pose(Mandible, eye(4));
pose(RightI, eye(4));
pose(LeftI, eye(4));
%create window
w_plane = -3; %z-value for the window
window_vertices = [4 -3 w_plane ;4 3 w_plane ;-4 -3 w_plane ;-4 3 w_plane];
window_faces = [1 2 3; 2 3 4];
window_color = [0.7490    0.8000    0.9333];
window = patch('faces', window_faces, 'vertices', window_vertices, ...
'facecolor', window_color);

set(window, 'FaceAlpha', .2);
set(window, 'EdgeAlpha', 0);

axis([-4 4 -4 4 -4 4])
%campos([-0.0843   -4.8321  -69.1133])
view(0, -88)
 orig_eye_cent = (REcent+LEcent)/2;
 skull_cent = vert_center(cube1);
 
 
 fly = makecube(.01);
 rigidbody(fly)
 
 user_entry = 1;
 old_s_phi = 0;
 old_s_theta = 0;
 old_RE_phi = 0;
 old_RE_theta = 0;
 old_LE_phi = 0;
 old_LE_theta = 0;
 
 rx=[0 0]; rz=[0 0]; lx = [0 0]; lz = [0 0];
 flag = 0;
 user_entry = [0 0];
 display('Click on the window to set the fly or press any button to quit')
 while numel(user_entry)>1
%  user_entry = input('X and Z coords for fly or q\n');

user_entry = ginput(1);

 pose(fly, r4([],[user_entry(1) user_entry(2) w_plane]));
 obj_pos = vert_center(fly);
 
 s_theta = atan((obj_pos(2)-orig_eye_cent(2))/(obj_pos(3)-orig_eye_cent(3)));
 s_theta = -s_theta*.8;
 s_phi =atan((-obj_pos(1)+skull_cent(1))/(obj_pos(3)-skull_cent(3)));
 
 max_mand_rot = (old_s_theta - s_theta)*.2; 
%  final_pose = r4([s_phi s_theta 0]);
 
 for dt = 0:.03:1
     eye_mvmt = dt^(1/3);
     mand_mvmt = exp(-((dt-.5).^2)/.1);
     
     pose(fly, r4([],[obj_pos(1) obj_pos(2) w_plane]));
     
RE_cent = vert_center(RightI);
pre_RE_theta = atan((-obj_pos(2)+RE_cent(2))/(obj_pos(3)-RE_cent(3)));
%pre_RE_theta = pre_RE_theta + tan(obj_pos(3)-rz(2));
RE_theta = pre_RE_theta - s_theta*dt;
pre_RE_phi =atan((-obj_pos(1)+RE_cent(1))/(obj_pos(3)-RE_cent(3)));
%pre_RE_phi = pre_RE_phi + tan(obj_pos(1)-rx(2));
RE_phi = pre_RE_phi - s_phi*dt;

cur_RE_phi = RE_phi*eye_mvmt+old_RE_phi*(1-eye_mvmt);
cur_RE_theta = RE_theta*eye_mvmt+old_RE_theta*(1-eye_mvmt);
     pose(RightI, r4([cur_RE_phi, cur_RE_theta 0]));
     
LOSR_phi = (pre_RE_phi*eye_mvmt)+(old_RE_phi+old_s_phi)*(1-eye_mvmt);     
LOSR_theta = (pre_RE_theta*eye_mvmt)+(old_RE_phi+old_s_phi)*(1-eye_mvmt);      
%      
     
 LE_cent = vert_center(LeftI);
pre_LE_theta = atan((-obj_pos(2)+LE_cent(2))/(obj_pos(3)-LE_cent(3)));
LE_theta = pre_LE_theta - s_theta*dt;
%LE_theta = LE_theta + sin(obj_pos(3)-rz(2));
pre_LE_phi = atan((-obj_pos(1)+LE_cent(1))/(obj_pos(3)-LE_cent(3)));     
LE_phi = pre_LE_phi - s_phi*dt;
%LE_phi = LE_phi + sin(obj_pos(1)-lx(2));
cur_LE_phi = LE_phi*eye_mvmt+old_LE_phi*(1-eye_mvmt);
cur_LE_theta = LE_theta*eye_mvmt+old_LE_theta*(1-eye_mvmt);
     pose(LeftI, r4([cur_LE_phi, cur_LE_theta 0]));
     
LOSL_phi =     pre_LE_phi*eye_mvmt+(old_LE_phi+old_s_phi)*(1-eye_mvmt); 
LOSL_theta = (pre_LE_theta*eye_mvmt)+(old_LE_phi+old_s_phi)*(1-eye_mvmt); 
     
     

 rx = [RE_cent(1)  RE_cent(1)-tan(LOSR_phi)*(RE_cent(2)+w_plane)];
 ry = [RE_cent(2) -RE_cent(3)+tan(LOSR_theta)*abs(RE_cent(3)-w_plane)];
 rz = [RE_cent(3)   obj_pos(3)];
 
%          lr = line([RE_cent(1) obj_pos(1)], [RE_cent(2) obj_pos(2)],...
%             [RE_cent(3) obj_pos(3)]);
% lx = [LE_cent(1)  LE_cent(1)+tan(cur_LE_phi)*(LE_cent(2)+w_plane)];
% ly = [LE_cent(2) obj_pos(2)];
% lz = [LE_cent(3)   LE_cent(3)+tan(cur_LE_theta)*(LE_cent(2)+w_plane)];
 lx = [LE_cent(1)  LE_cent(1)-tan(LOSL_phi)*(LE_cent(2)+w_plane)];
 ly = [LE_cent(2) -LE_cent(2)+tan(LOSL_theta)*abs(LE_cent(3)-w_plane)];
 lz = [LE_cent(3)   obj_pos(3)];
 if rays == 1
     delete(lr)
     delete(ll)
     lr = line(rx, ry, rz);
     ll = line(lx, ly, lz);

% 
%          ll = line([LE_cent(1) obj_pos(1)], [LE_cent(2) obj_pos(2)],...
%             [LE_cent(3) obj_pos(3)]);
     end
     
     
     mand_rot_angle = max_mand_rot*mand_mvmt;
     if mand_rot_angle < 0 
         mand_rot_angle = 0;
     end
pose(Mandible, r4([0 mand_rot_angle 0]));
     
     
 pose(Skull, r4([old_s_phi*(1-dt)+s_phi*dt  old_s_theta*(1-dt)+s_theta*dt  0]));
 
 obj_pos = obj_pos +.1*[(rand(1,2)-.5) 0];
 drawnow;
 
 end
 while buttons == 0
     obj_pos = obj_pos +.1*[(rand(1,2)-.5) 0];
     
 end    
 old_s_theta = s_theta;
 old_s_phi = s_phi;
 old_RE_phi = RE_phi;
 old_RE_theta = RE_theta;
 old_LE_phi = LE_phi;
 old_LE_theta = LE_theta;
 end
 delete(fly)
 delete(window)
 delete(ll)
 delete(lr)
 pose(Skull, eye(4));
pose(Mandible, eye(4));
pose(RightI, eye(4));
pose(LeftI, eye(4));
catch
 delete(fly)
 delete(window)
 delete(ll)
 delete(lr)
 pose(Skull, eye(4));
pose(Mandible, eye(4));
pose(RightI, eye(4));
pose(LeftI, eye(4));
end