function [center radius] = vert_center(obj)

vertices = get(obj, 'vertices');
center = mean(vertices);

x_radius = .5 * (max(vertices(:,1)) - min(vertices(:,1)));
y_radius = .5 * (max(vertices(:,2)) - min(vertices(:,2)));
z_radius = .5 * (max(vertices(:,3)) - min(vertices(:,3)));

radius = (x_radius + y_radius + z_radius)/3;