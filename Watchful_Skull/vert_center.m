function [center radius] = vert_center(obj)
%function [center radius] = vert_center(obj)
%vert_center finds the mean coordinates of the vertices of obj, and the
%average 'radius', which has meaning only in spherical objects.  Designed
%to find the center and radius of an eye.
%Ryan George
%COMO 401

vertices = get(obj, 'vertices');
center = mean(vertices);  %average vertices across each coordinate

%find maximum distance between vertices in x, y, and z coordinates
x_radius = max(vertices(:,1)) - min(vertices(:,1));
y_radius = max(vertices(:,2)) - min(vertices(:,2));
z_radius = max(vertices(:,3)) - min(vertices(:,3));

%average radius across dimensions and divide by 2 to get radius
radius = (x_radius + y_radius + z_radius)/6;