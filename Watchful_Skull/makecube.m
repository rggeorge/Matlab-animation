function cube = makecube(size, color)
%function cube = makecube(size, color)
%Creates rigid cube centered at [0 0 0] with vertices 
%at [+/-size +/-size +/-size] and given colo(u)r.
%Ryan George
%COMO401

if nargin < 1 %makecube()
    size = .5;
end

if nargin<2 %makecube(size)
    color = rand(1,3);
end

cube_vertices = [0 0 0; 1 0 0; 1 1 0; 0 1 0; 0 0 1; 1 0 1; 1 1 1; 0 1 1];
%center cube at origin and (vertices at +/-1)
cube_vertices = (cube_vertices - ones(8,1)*[.5 .5 .5])*2;
%scale to given size
cube_vertices = cube_vertices*size;

cube_faces = [1 2 5; 5 2 6; 2 3 6; 6 3 7; 3 8 7; 8 3 4;...
              4 1 8; 8 1 5; 5 6 8; 8 6 7; 1 2 4; 4 2 3];
          
cube = patch('faces', cube_faces, 'vertices', cube_vertices, ...
'facecolor', color);

%make cube a rigid body
rigidbody(cube); 