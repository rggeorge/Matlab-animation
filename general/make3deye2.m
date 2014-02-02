function eyehandle = make3deye(name, radius, nsegs, iriscolour)

% eyehandle = make3deye(name, nsegs, iriscolour)
% unit radius spherical eye centred at 0, looking along z
% specify iris colour as 1x3 rgb array
% userdata.pose is 4D pose matrix
% MGP June 2004

% save hold state and set hold on
% (surf over-writes!)
nothold = false;
if ~ishold
    nothold = true;
    hold on
end

if nargin<4
    iriscolour = [0 .2 .9];
end
if nargin<3
    nsegs = 32;
end
if nargin<2
    radius = 1;
end
if nargin==0
    name = 'aneye';
end

[x,y,z] = sphere(nsegs);
surfsphere = surf(radius*x,radius*y,radius*z);
[faces, vertices] = surf2patch(surfsphere, 'triangles'); delete(surfsphere);
[Nface, jnk] = size(faces);
eyehandle = patch('faces', faces, 'vertices', vertices, ...
    'facecolor', 'flat', 'edgecolor', 'none');

% eye white
colour = ones(Nface, 1)*[1 .975 .975];

% iris colour
iris = find(vertices(:,3)>.8*radius);
iface = [];
for i=1:length(iris)
    [j, jnk] = ind2sub(size(faces), find(faces==iris(i)));
    iface = [iface; j];
end
colour(iface, :) = .95*ones(length(iface), 1)*iriscolour + .05*randn(length(iface), 3);

% pupil black
pupil = find(vertices(:,3)>.98*radius);
iface = [];
for i=1:length(pupil)
    [j, jnk] = ind2sub(size(faces), find(faces==pupil(i)));
    iface = [iface; j];
end
colour(iface, :) = zeros(length(iface), 3);
colour(iface(1),:) = ones(1,3);


set(eyehandle, 'facevertexcdata', colour);
set(gca, 'dataaspectratio', [1 1 1], 'visible', 'off');
lite = findobj(gca, 'type', 'light');
if isempty(lite)
    lite = light;
    set(lite, 'position', [50 -100 50]);
    lighting gouraud
end

rigidbody(eyehandle, name);

% restore hold state
if nothold
    hold off
end