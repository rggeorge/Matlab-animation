%watchfly.m
%'watchfly' animates the skull set up by setup.m to watch a fly. The 'rays' 
%option draws a line along each eye's axis to show its orientation.The user 
%clicks on the window, and at that spot a fly appears and begins crawling 
%around randomly.  The skull turns to watch the fly and tracks it with its 
%eyes. After the skull has finished moving, the user can again place the 
%fly by clicking the window.  Clicking on the red sqare will quit the script.

%Ryan George
%COMO 401

%get user input on rays, set flag 'rays' at 0 (false) or 1 (true)
rays_input = input('Show rays along eye axes? y/n\n', 's');
if strcmp(rays_input, 'y') || strcmp(rays_input, 'Y') || strcmp(rays_input, 'yes')
    rays = 1;
    raycolor = [1 .6 0];
    %create objects rline and lline to prevent an error the first time 
    %they are deleted
    rline = drawray(RightI, RightI, raycolor);
    lline = drawray(LeftI, LeftI, raycolor);
else
    rays = 0;
end

%pose skull and mandible in regular position
pose(Skull, eye(4));
pose(Mandible, eye(4));

%create window
w_plane = -3; %y-value for window plane
window_vertices = [4 w_plane -3  ;4 w_plane 3  ;-4 w_plane -3  ;-4 w_plane 3 ];
window_faces = [1 2 3; 2 3 4];
window_color = [0.7490    0.8000    0.9333];
window = patch('faces', window_faces, 'vertices', window_vertices, ...
'facecolor', window_color);
set(window, 'FaceAlpha', .2);
set(window, 'EdgeAlpha', 0);

%create red stopping 'button'
xsvals = [3.25 3.75];
zsvals = [-2.75 -2.25];
stop_plane = -3; %y-value for the button
stop_vertices = [xsvals(1) w_plane zsvals(1)  ;xsvals(1) w_plane  zsvals(2) ;...
                 xsvals(2) w_plane zsvals(1)  ;xsvals(2) w_plane zsvals(2) ];
stop_faces = [1 2 3; 2 3 4];
stop_color = [1 0 0];
stop = patch('faces', stop_faces, 'vertices', stop_vertices, ...
'facecolor', stop_color);
set(stop, 'EdgeAlpha', 0);

%position camera in a good place
axis([-4 4 -4 4 -4 4])
campos([ 25.5592  -63.2613   12.0307])

%make fly object
fly = makecube(.01, [0 0 0]);
 
%record orientation of skull.  phi is left/right, theta is up/down rotation
%of skull.  When animation is done, to give smoothness, the skull moves
%from orientation 'old_s_...' to new orientation 's_...'
old_s_phi = 0;
old_s_theta = 0;

%create dummy object for eyes to track.  This object is invisible.
dummy_target = makecube(.1);
set(dummy_target, 'Visible', 'off')
%set dummy target right in front of eyes to start out
pose(dummy_target, r4([], [0 w_plane .55]));
%pose eyes to look at dummy_object
lookat(RightI, dummy_target);
lookat(LeftI, dummy_target);

%let user click window
display('Click on the window to set the fly or click on the red square to exit')
k = waitforbuttonpress;
f_input = get(gca, 'CurrentPoint');

%find the intersection of the line-of-sight at user's click and the window 
%y = w_plane.  These lines use the linear property:
%    (y-in(2))            (x-in(1))            (z-in(3))
%  -------------   =   --------------   =   --------------   ( = ratio)
%  (out(2)-in(2))      (out(1)-in(1))       (out(2)-in(2))
%where 'in' is the coordinates where the line-of-sight enters the axes
%( f_input(1,:) ) and 'out' is where it exits the axes ( f_input(2,:) )
ratio = (w_plane - f_input(1,2))/(f_input(2,2)-f_input(1,2));
fx_coord = (f_input(2,1)-f_input(1,1))*ratio + f_input(1,1);
fz_coord = (f_input(2,3)-f_input(1,3))*ratio + f_input(1,3);
     
while k==0 %until 'break' 
 
    %break out of while loop if user clicks on red stop button
    if all([(fx_coord < xsvals)== [0 1] (fz_coord < zsvals)== [0 1]])
        break
    end
    
    %position fly where user clicked
    pose(fly, r4([],[fx_coord w_plane fz_coord]));
    fly_coords = vert_center(fly);
 
    %find 'center of visual attention' between eyes
    eye_cent = (vert_center(RightI)+vert_center(LeftI))/2;
    fly_re_skull = pose(fly, cube2);
    
    %calculate skull rotation so that 'center of visual attention' points
    %toward fly
    s_theta = atan(fly_re_skull(1,4)/abs(w_plane));
    s_phi = -atan(fly_re_skull(3,4)/abs(w_plane));

    for t = 0:.04:1 %skull, mandible, and eye animation
        %define function to govern movement of dummy object toward fly.
        %plot to see movement of eyes from t = 0 : 1
        eye_mvmt = t^(1/4); 
        %have fly buzz around
        fly_coords = fly_coords +.2*[rand-.5 0 rand-.5];
        pose(fly, r4([],[fly_coords(1) w_plane fly_coords(3)]));
        
        %move dummy object from old fly position toward new fly position 
        %as dictated by eye_mvmt
        pose(dummy_target, pose(fly)*eye_mvmt + pose(dummy_target)*(1-eye_mvmt))
        %rotate eyes
        lookat(RightI, dummy_target)
        lookat(LeftI, dummy_target)

        if rays == 1
            %delete old rays
            delete([rline lline])
            %draw new rays between eye and target
            rline = drawray(RightI, dummy_target, raycolor);
            lline = drawray(LeftI, dummy_target, raycolor);
        end
        %function to govern movement of mandible (visualize with ezplot)
        mand_mvmt = .6*(exp(-((t-.5).^2)/.2)-.2865)*exp(-((t+1).^2)/2);
        %calculate mandible movement based on skull movement
        %(mandible rotates in proportion to upward movement of skull)
        mand_rot_angle = (old_s_phi-s_phi)*mand_mvmt;
        mand_rot_angle(mand_rot_angle < 0) = 0; %no backwards rotation
        pose(Mandible, r4([0 mand_rot_angle 0]));
        
        %function to govern skull movement
        skull_mvmt = t*(2-t);
        %skull moves smoothly between old direction of fly and new direction
        pose(Skull, r4([old_s_theta*(1-skull_mvmt)+s_theta*skull_mvmt ...
                        old_s_phi*(1-skull_mvmt)+s_phi*skull_mvmt  0]));
        drawnow;
    end %end of skull and mandible movement until fly is set again
    
    %get point of last click
    oldpt = get(gca, 'CurrentPoint');
    flag = 0; %changes upon click
    
    while flag == 0 %while no click
        %fly buzzes around
        fly_coords = fly_coords +.2*[rand-.5 0 rand-.5];
        pose(fly, r4([],[fly_coords(1) w_plane fly_coords(3)]));
        
        %eyes watch fly directly, not dummy object
        lookat(RightI, fly);
        lookat(LeftI, fly);
    
        if rays == 1 %draw rays
            delete([rline lline])
            rline = drawray(RightI, fly, raycolor);
            lline = drawray(LeftI, fly, raycolor);
        end
        drawnow;
        
        %pause to keep this loop in similar time as previous (for) loop
        pause(.02) 
        
        f_input = get(gca, 'CurrentPoint'); %get last click
        if any(any(f_input ~= oldpt)) %if user has clicked since loop started
            %calculate place on window
            ratio = (w_plane - f_input(1,2))/(f_input(2,2)-f_input(1,2));
            fx_coord = (f_input(2,1)-f_input(1,1))*ratio + f_input(1,1);
            fz_coord = (f_input(2,3)-f_input(1,3))*ratio + f_input(1,3); 
            flag = 1; %set flag to break out of while loop
        end 
    end
    %record current skull orientation
    old_s_theta = s_theta;
    old_s_phi = s_phi;
    %pose dummy object at fly for smoothness of eyes
    pose(dummy_target, r4([],[fly_coords(1) w_plane fly_coords(3)]))
end
%when user clicks square stop button, delete these objects
delete([fly window lline rline stop])
%reset skull positions
pose(Skull, eye(4));
pose(Mandible, eye(4));
pose(RightI, eye(4));
pose(LeftI, eye(4));