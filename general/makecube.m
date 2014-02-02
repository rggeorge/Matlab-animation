function cube = makecube(size, color)
%function cube = makecube(size, color)
%creates cube centered at [0 0 0 ] 
%with vertices at [-size -size -size]
%and [size size size]
if nargin<2
    color = rand(1,3);
end
cube_vertices = [0 0 0; 1 0 0; 1 1 0; 0 1 0; 0 0 1; 1 0 1; 1 1 1; 0 1 1];
cube_vertices = (cube_vertices - ones(8,1)*[.5 .5 .5])*2;
cube_vertices = cube_vertices*size;

cube_faces = [1 2 5; 5 2 6; 2 3 6; 6 3 7; 3 8 7; 8 3 4;...
              4 1 8; 8 1 5; 5 6 8; 8 6 7; 1 2 4; 4 2 3];
          
cube = patch('faces', cube_faces, 'vertices', cube_vertices, ...
'facecolor', color);