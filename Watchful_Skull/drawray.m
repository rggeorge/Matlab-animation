function ray = drawray(obj1, obj2, color)
%function drawray(obj1, obj2)
%drawray draws a line between the center of obj1 and the center of obj2 of
%given color
%Ryan George
%COMO 401

if nargin < 3 %drawray(obj1, obj2)
    color = rand(3,1);
end

%get and assemble eye and target coordinates for line endpoints
obj1cent = vert_center(obj1);
obj2cent = vert_center(obj2);
x = [obj1cent(1) obj2cent(1)]; 
y = [obj1cent(2) obj2cent(2)];
z = [obj1cent(3) obj2cent(3)];
%draw ray
ray = line(x, y, z, 'Color', color);
