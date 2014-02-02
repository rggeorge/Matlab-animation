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

objects = {'Skull', 'Mandible', 'Upperteeth', 'Lowerteeth', 'RightEye', 'LeftEye'};


for j = 1:numel(objects)
    rigidbody(eval(objects{j}), objects{j});
end

for k = 2:numel(objects)
    assign_child(Skull, eval(objects{k}));
end
assign_child(Mandible, Lowerteeth)

pose(Skull, r4([-pi/2 -pi/2 -pi/2], [.2 .35 0]));

for j = 1:numel(objects)
    rigidbody(eval(objects{j}), objects{j});
end

for k = 2:numel(objects)
    assign_child(Skull, eval(objects{k}));
end
axwidget;
assign_child(Mandible, Lowerteeth)


cube1 = makecube(.01);
rigidbody(cube1);
pose(cube1,r4([0 0 pi/2]));

cube2 = makecube(.01);
rigidbody(cube2);
pose(cube2,r4([pi/2 pi/2 pi]));
assign_child(cube1, cube2);
assign_child(cube2, Skull);
for j = 1:numel(objects)
    rigidbody(eval(objects{j}), objects{j});
end
assign_child(cube2, Skull);
for k = 2:numel(objects)
    assign_child(Skull, eval(objects{k}));
end

[LEcent radius] = vert_center(LeftEye);
cubeLE1 = makecube(.02);
cubeLE2 = makecube(.02);
new_vertices = get(cubeLE1, 'vertices')+ ones(size(get(cubeLE1, 'vertices'),1),1)*LEcent;
set(cubeLE1, 'vertices', new_vertices);
rigidbody(cubeLE1)
set(cubeLE2, 'vertices', new_vertices);
rigidbody(cubeLE2)
assign_child(Skull, cubeLE1)
assign_child(cubeLE1, cubeLE2)
%pose(cubeLE2, r4([pi/2 0 0]));



LeftI = make3deye2('LeftI', radius, 64, iris_colour);
rigidbody(LeftI);
pose(LeftI, r4([0 -pi/2 0 ], LEcent));
rigidbody(LeftI);
assign_child(cubeLE2, LeftI)



REcent = vert_center(RightEye);
cubeRE1 = makecube(.02);
cubeRE2 = makecube(.02);
new_vertices = get(cubeRE1, 'vertices')+ ones(size(get(cubeLE1, 'vertices'),1),1)*REcent;
set(cubeRE1, 'vertices', new_vertices);
rigidbody(cubeRE1)
set(cubeRE2, 'vertices', new_vertices);
rigidbody(cubeRE2)
assign_child(Skull, cubeRE1)
assign_child(cubeRE1, cubeRE2)


RightI = make3deye2('RightI', radius, 64, iris_colour);
set(RightI, 'vertices', get(RightI, 'vertices'))
rigidbody(RightI);
pose(RightI, r4([0 -pi/2 0 ], REcent));
rigidbody(RightI);

assign_child(cubeRE2, RightI)