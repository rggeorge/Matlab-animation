%retrieve skull, set up animation

clear
clf

asc2fig('skull_to_import.asc');
daspect([1 1 1]);
c = get(gca, 'children');
set(c, 'EdgeColor', 'none');
L = light;
lighting gouraud
camfreeze

bone_color = [0.9412    0.9451    0.8039];
tooth_color = [0.9882    0.9882    0.9490];
eye_color = [1.0000    0.9686    0.9686];
iris_colour = [0.1922    0.3451    0.2745];

set([Skull Mandible], 'FaceColor', bone_color);
set([Upperteeth Lowerteeth], 'FaceColor', tooth_color);
set([LeftEye RightEye], 'FaceColor', eye_color);
set([JawAxis Pivotpt Lec Rec LeftEye RightEye], 'Visible', 'off')

objects = {'Skull', 'Mandible', 'Upperteeth', 'Lowerteeth'};%, 'RightEye', 'LeftEye'};

%%%%%%
[LEcent radius] = vert_center(LeftEye);
cubeLE1 = makecube(.02);
cubeLE2 = makecube(.02);
rigidbody(cubeLE1)
% pose(cubeLE1, r4([], LEcent));
rigidbody(cubeLE2)
% pose(cubeLE2, r4([], LEcent));
% rigidbody(cubeLE2)
% 
% assign_child(Skull, cubeLE1)
% assign_child(cubeLE1, cubeLE2)
% set_user_data(cubeLE1, 'jointype', 'w');



LeftI = make3deye2('LeftI', radius, 64, iris_colour);
rigidbody(LeftI);
% pose(LeftI, r4([0 pi/2 0 ], LEcent));
% rigidbody(LeftI);
% assign_child(cubeLE2, LeftI)



REcent = vert_center(RightEye);
cubeRE1 = makecube(.02);
cubeRE2 = makecube(.02);
rigidbody(cubeRE1)
% pose(cubeRE1, r4([], REcent));
rigidbody(cubeRE2)
% pose(cubeRE2, r4([], REcent));
% rigidbody(cubeRE1)
% pose(cubeRE1, r4([], REcent + [.2 .35 0]));

% pose(cubeRE2, r4([], LEcent));
% rigidbody(cubeRE2)
% 
% assign_child(Skull, cubeRE1)
% assign_child(cubeRE1, cubeRE2)
% set_user_data(cubeRE1, 'jointype', 'w');

RightI = make3deye2('RightI', radius, 64, iris_colour);
rigidbody(RightI);
% pose(RightI, r4([0 pi/2 0 ], REcent));
% rigidbody(RightI);
% 
% assign_child(cubeRE2, RightI)
%%%%%%%%%%
%&&&&&&
cube1 = makecube(.01);
rigidbody(cube1);
set(cube1, 'Visible', 'off')
cube2 = makecube(.01);
rigidbody(cube2);
set(cube2, 'Visible', 'off')
pose(cube1,r4([0 0 0], [0 .4 0 ]));
pose(cube2,r4([pi/2 pi/2 pi], [0 .4 0 ]));
assign_child(cube1, cube2);
% rigidbody(cube1);
% rigidbody(cube2);
%&&&&&&&
mand_cube = makecube(.01);  %dummy object for mandible rotation
rigidbody(mand_cube);
set(mand_cube, 'Visible', 'off')


for j = 1:numel(objects)
    rigidbody(eval(objects{j}), objects{j});
end

pose(Skull, r4([], [0 .4 0]));
assign_child(cube2, Skull)
pose(Skull, r4([], [0 -.4 0]));

assign_child(Skull, mand_cube)
pose(mand_cube, r4([], [0 .11 .2]));
assign_child(mand_cube, Mandible)
assign_child(Mandible, Lowerteeth)


assign_child(Skull, cubeRE1)
assign_child(Skull, cubeLE1)
assign_child(cubeRE1, cubeRE2)
assign_child(cubeLE1, cubeLE2)

pose(LeftI, r4([0 pi/2 0]));
pose(RightI, r4([0 pi/2 0]));
assign_child(cubeRE2, RightI)
assign_child(cubeLE2, LeftI)
pose(cubeRE1, r4([],REcent));
pose(cubeLE1, r4([],LEcent));

assign_child(Skull, Upperteeth)

pose(cube1,r4([0 pi/2 0], [0 .4 0 ]));

pose(Mandible, r4([0 pi/12 0]));
% for k = 2:numel(objects)
%     assign_child(Skull, eval(objects{k}));
% end
%18 .11 0]));

% for j = 1:numel(objects)
%     rigidbody(eval(objects{j}), objects{j});
% end
% 
% for k = 2:numel(objects)
%     assign_child(Skull, eval(objects{k}));
% end
% axwidget;
% assign_child(Mandible, Lowerteeth)
% assign_child(Skull, cubeLE1)
% assign_child(cubeLE1, cubeLE2)
% assign_child(cubeLE2, LeftI)
% 
% assign_child(Skull, cubeRE1)
% assign_child(cubeRE1, cubeRE2)
% assign_child(cubeRE2, RightI)
% 
% 
% cube1 = makecube(.01);
% rigidbody(cube1);
% pose(cube1,r4([0 0 pi/2], [-.2 -.35  0 ]));
% 
% cube2 = makecube(.01);
% rigidbody(cube2);
% pose(cube2,r4([pi/2 pi/2 pi], [-.2 -.35  0 ]));
% assign_child(cube1, cube2);
% assign_child(cube2, Skull);
% % for j = 1:numel(objects)
% %     rigidbody(eval(objects{j}), objects{j});
% % end
% assign_child(cube2, Skull);
% for k = 2:numel(objects)
%     assign_child(Skull, eval(objects{k}));
% end
% 
