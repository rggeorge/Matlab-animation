function varargout = string2d(L,D, nwobble,d, radius, lres, cres)

% function [vertices, faces] = string2d(L,D, n,d, radius, lres, cres)
% (for 3D modeling 2D strings and springs)
% vertex and face data for a piece of string L units long
% reaching from [0 0 0] to [D 0 0] with n periods of a sinusoidal wobble
% with a straight bit at each end of length d
% nb the string extends in the +x direction from the origin & lies in the
% x-y plane (just so it plots nice without further ado).
%
%             n cycles
%        _             _
%       / \           / \
%   ---/   \   / ... /   \   /---  total string (path) length = L
%           \_/           \_/
%   <d>
%   <------------ D ------------>
%
% lres is linear spatial resolution expressed as #segments per 1/8 cycle, default 2
% cres is circumferential resolution, # segments on circumference, default 16
% radius is the string radius, default string length/100;
%
% if <2 output arguments, it draws the string and returns the handle if requested
% single input argument arg = [handle newlength] is used to alter the length
% of an existing string
%
% MGP August 2006

if nargin==1
    h = L(1); % handle of existing string
    D = L(2); % new length of existing string

    % get existing string parameters
    u = get(h, 'userdata');
    L = u.stringlength;
    nwobble = u.nwobble;
    d = u.endseglength;
    radius = u.radius;
    lres = u.lres;
    cres = u.cres;
else
    % default parameters
    if nargin<7
        cres = 16;
    end
    if nargin<6
        lres = 4;
    end
    if nargin<5
        radius = L/100;
    end
    if nargin<4
        d = L/10;
    end
    if nargin<3
        nwobble = 1;
    end
end

if D>2*d & D<L % string has a wavy bit 
               % (is longer than the terminal segments & spans less than its length)

L0 = L-2*d;  % length of the wavy bit of the string
D0 = D-2*d;  % distance spanned by the wavy bit
a = stringwobble(L0, nwobble, D0);  % how much does the string wobble to span D0 with length L0
w  = nwobble/D0;
Dend = D0/(4*nwobble);
dx = Dend/lres;
x = Dend:dx:(D0-Dend);
y = a*sin(2*pi*w*x);


% straighten ends w/ splines
c0 = cspline([dx d+Dend], [0 y(1)], [0 0]); % max((y(2)-y(1))/dx]);
c1 = cspline([d+D0-Dend D-dx], [y(end) 0], [ 0 0 ]); %(y(end)-y(end-1))/dx 0]);
xhead = dx:dx:(d+Dend-dx);
xtail = (d+D0-Dend+dx):dx:(D-dx);
x = [0 xhead d+x xtail D];
y = [0 polyval(c0, xhead) y polyval(c1, xtail) 0];

path = [x(:), y(:), zeros(size(x(:))) ];

else
  path = [ 0 0 0; D 0 0];
end

if length(radius)==1
    radius = radius*ones(size(path,1));
end

% tangent unit vector
t = diff(path);
sing = find(sum(t,2) == 0);
if(~isempty(sing))
    t(sing,:) = [];
end
t(end+1,:) = t(end,:);
normed = [sum(t'.^2).^.5]';
normed = [normed, normed, normed];
t = t./normed;

n = repmat(sum(t.*t,2),1,3).*repmat([0 0 1],size(t,1),1) - repmat(sum(repmat([0 0 1],size(t,1),1).*t,2),1,3).*t;
normed = [sum(n'.^2).^.5]';
normed = [normed, normed, normed];
n = n./normed;


b = cross(t,n);
normed = [sum(b'.^2).^.5]';
normed = [normed, normed, normed];
b = b./normed;


rx = []; ry = []; rz = [];
N = size(n,1);
for i=1:N
    M = [n(i,:);b(i,:);t(i,:)];
    f = radius(i)*exp(j*[0:2*pi/cres:2*pi]);
    r = inv(M)*[imag(f); real(f); zeros(size(f))];
    rx = [rx; r(1,1:cres) + path(i,1)];
    ry = [ry; r(2,1:cres) + path(i,2)];
    rz = [rz; r(3,1:cres) + path(i,3)];
end

vertices = [rx(:) ry(:) rz(:)];

% stitch vertices to make faces
faces = zeros(2*(N-1)*cres,3);
c=0;
for i = 1:(cres-1)
    for k = 1:(N-1)
        c = c+1;
        faces(c,:) = [ (i-1)*N+k  i*N+k (i-1)*N+k+1];
        c=c+1;
        faces(c,:) = [(i-1)*N+k+1 i*N+k i*N+k+1];
    end
end
% fill in the gap

for k=1:(N-1)
    c=c+1;
    faces(c,:) = [ (cres-1)*N+k  k (cres-1)*N+k+1];
    c=c+1;
    faces(c,:) = [(cres-1)*N+k+1 k k+1];
end

if nargout<2       % render string
    if nargin==1
        u = get(h, 'userdata');
        if isfield(u, 'rigidbody')  % string is a rigidbody object
            u.vertices = [vertices ones(size(vertices,1),1)]; % set rigidbody default vertices (no render)
            u.faces = faces;
        else
            set(h, 'faces', faces,'vertices', vertices);   % alter existing string

        end
    else
        h = patch('faces', faces, 'vertices', vertices);  % draw new
    end
    u.stringlength=L;
    u.stringspan=D;
    u.nwobble=nwobble;
    u.endseglength=d;
    u.radius=radius(1);
    u.lres=lres;
    u.cres=cres;
    set(h, 'userdata', u);
    varargout{1} = h;
else
    varargout{1} = vertices;
    varargout{2} = faces;
end




