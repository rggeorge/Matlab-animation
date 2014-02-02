%setup.m
%'setup' retrieves the objects which compose the skull and makes them rigid
%bodies. Objects are set in pose and parent/child heirarchy suitable for 
%animation. Camera position and options are also set up.
%Ryan George 2009
%COMO401, Assignment One

clear
clf

%create objects using ascii importer
asc2fig('skull_to_import.asc');

%set camera and lighting properties
daspect([1 1 1]);
c = get(gca, 'children');
set(c, 'EdgeColor', 'none');
L = light;
lighting gouraud
camfreeze
axis([-4 4 -4 4 -4 4]);
campos([36.3737  -57.6733   12.2842]);

%make the following objects rigid bodies
objects = {'Skull', 'Mandible', 'Upperteeth', 'Lowerteeth'};
for j = 1:numel(objects)
    rigidbody(eval(objects{j}), objects{j});
end

%set colors
bone_color = [0.9412    0.9451    0.8039];
tooth_color = [0.9882    0.9882    0.9490];
iris_colour = [0.1922    0.3451    0.2745];
set([Skull Mandible], 'FaceColor', bone_color);
set([Upperteeth Lowerteeth], 'FaceColor', tooth_color);
%make placeholders invisible
set([LEye REye], 'Visible', 'off')

%create dummy objects to go at the base of the skull
cube1 = makecube(.01);
set(cube1, 'Visible', 'off')
cube2 = makecube(.01);
set(cube2, 'Visible', 'off')
%put dummy objects in correct position relative to skull
pose(cube1,r4([0 0 0], [0 .4 0 ]));
pose(cube2,r4([], [0 .4 0 ]));
assign_child(cube1, cube2);
%connect skull to dummy object
pose(Skull, r4([], [0 .4 0]));
assign_child(cube2, Skull)
pose(Skull, r4([], [0 -.4 0]));

%create dummy object for mandible to rotate around
mand_cube = makecube(.01); 
set(mand_cube, 'Visible', 'off')
assign_child(Skull, mand_cube)
%place it in a spot of natural-looking rotation
pose(mand_cube, r4([], [0 .11 .2]));
%connect mandible and lower teeth
assign_child(mand_cube, Mandible)
assign_child(Mandible, Lowerteeth)

%find center and radius of Left Eye created in Esperient
[LEcent radius] = vert_center(LEye);
%make dummy objects for the center of the left eye
cubeLE1 = makecube(.02);
cubeLE2 = makecube(.02);
%create visible left eye
%note that LeftI, NOT LEye, is the functional and visible eye object
LeftI = eyepatch('LeftI', radius, 64, iris_colour);
rigidbody(LeftI)

%create right eye
REcent = vert_center(REye);
cubeRE1 = makecube(.02);
cubeRE2 = makecube(.02);
RightI = eyepatch('RightI', radius, 64, iris_colour);
rigidbody(RightI)
%smooth eye lighting
set([RightI LeftI], 'FaceLighting', 'gouraud')

%connect eyes and dummy objects
%order: Skull - cube_E1 - cube_E2 - Eye
assign_child(Skull, cubeRE1)
assign_child(Skull, cubeLE1)
assign_child(cubeRE1, cubeRE2)
assign_child(cubeLE1, cubeLE2)
assign_child(cubeRE2, RightI)
assign_child(cubeLE2, LeftI)
pose(cubeRE1, r4([0 pi/2 0],REcent));
pose(cubeLE1, r4([0 pi/2 0],LEcent));

%connect upper teeth
assign_child(Skull, Upperteeth)
pose(cube1,r4([], [0 .4 0 ]));

%skull says hello!
pose(Mandible, r4([0 pi/12 0]));