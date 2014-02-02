function h = tube(x,y,z,r, varargin)

% function h = tube(x,y,z,r, <name/value pairs>)
% tube of radius r around line (x,y,z)
% (not a rigidbody)
%
% optional arguments:
%    tangent  = {0} - nx3 array of unit tangents at each point (x,y,z)
%    colour   = {[1 1 1]*.5}
% edgecolour  = {'none'}
% leftclosed  = {false} | true
% rightclosed = {false} | true
%    closed   = {false} | true  [closed at both ends] 
% npoints     = {16}            [number of points around circumference]
%
% Dyanimat toolbox
% (c) Michael G Paulin 2005

colour = [1 1 1]*.5;
edgecolour = 'none';
tangent = [];
if numel(r)==1
    r = r*ones(size(x));
end
npoints = 16;
leftclosed = false;
rightclosed = false;


N = length(varargin);
for i=1:2:N  % extract name-value pairs
    name  = varargin{i};
    value = varargin{i+1};
    if ~ischar(name) % fatal
        error('properties must be specified as property name/value pairs');
        return
    else
        switch lower(name)
            case 'tangent'
                tangent = value;
            case 'npoints'
                npoints = value;
            case 'leftclosed'
                leftclosed = value;
            case 'rightclosed'
                rightclosed = value;
            case 'closed'
                rightclosed = value;
                leftclosed = value;
            case {'colour', 'color'}
                colour  = value;
            case {'edgecolour','edgecolor'}
                edgecolour = value;
            otherwise  % fatal
                error(['unrecognized stick property (' name ')']);
                return

        end
    end
end


N = length(x);

% get tangent at each point if not specified, & normalize
if isempty(tangent)
    tangent = gettangent(x,y,z);
end
for i=1:N
    tangent(:,i) = tangent(:,i)/norm(tangent(:,i));
end

% unit vectors perpendicular to plane containing 
% the line segments on each side of each point
% these are radius vectors to first point on circumference in each segment
u1 = unitperp2(tangent);

% smooth and renormalize
u2 = u1;
% first deal with special case: consecutive vectors antiparallel
for i=2:N
    if u2(:,i-1)'*u2(:,i)<1e-3
        u2(:,i) = -u2(:,i);
    end
end
u1 = u2;  
% now boxcar smooth the radius vectors so they don't twist sharply 
% across segments
for i=1:N
    u2(:,i) = u2(:,i) + u1(:,max(1, i-1)) + u1(:, min(N,i+1));
    u2(:,i) = u2(:,i)/norm(u2(:,i));
end
u1 = u2;

% unit vectors so that {u1, u2, tangent} form rh basis
for i=1:N
    u2(:,i) = cross(tangent(:,i), u1(:,i));
end

% form polygon at each 'joint' of the tube
X = zeros(npoints*N, 3);
for i=1:N
    for j=0:(npoints-1)
        X(npoints*(i-1)+j+1, :) = [x(i) y(i) z(i)] + r(i)*(cos(2*pi*j/npoints)*u1(:,i)' + sin(2*pi*j/npoints)*u2(:,i)');
    end
end

% stitch up faces
F = zeros((N-1)*npoints*2,3);
for i=1:N-1
    twist = abs(u1(:,i)'*u1(:,i+1))<1/sqrt(2);  % inflection on curve -> twist in tube
    if twist 
        disp(i)
    end
    for j=1:npoints
        k = j+1; 
        if k>npoints, k=k-npoints; end
        k2 = j-4*twist;
        if k2>npoints, k2=k2-npoints; end
        F((i-1)*2*npoints+2*j-1,:) = [(i-1)*npoints+j i*npoints+j (i-1)*npoints+k];
%         F((i-1)*2*npoints+2*j-1,:) = [(i-1)*npoints+j i*npoints+k2 (i-1)*npoints+k];
%         F((i-1)*2*npoints+2*j,:) = [(i-1)*npoints+j i*npoints+k2 (i-1)*npoints+k];
        F((i-1)*2*npoints+2*j  ,:) = [(i-1)*npoints+k i*npoints+j   i*npoints+k];
    end
end
Rightend = size(X,1);

% close left end
if leftclosed
    X = [X; [x(1) y(1) z(1)]];
    for j=1:npoints
        k=j+1; if k>npoints, k=1; end
        F = [F; [j k Rightend+1]];
    end
end

% close right end
if rightclosed
    X = [X; [x(end) y(end) z(end)]];
    for j=1:npoints
        k=j+1; if k>npoints, k=1; end
        F = [F; [(N-1)*npoints+k (N-1)*npoints+j Rightend+1+leftclosed]];
    end
end


        
h = patch('faces', F, 'vertices', X);
set(h, 'facecolor', colour, 'edgecolor', edgecolour);

    

%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%%

function tangent = gettangent(x,y,z)

% tangent to curve at each point

N = length(x); 

% tangent at first point is parallel to the first segment
tangent(:,1) = [x(2)-x(1); y(2)-y(1); z(2)-z(1)];
tangent(:,1) = tangent(:,1);

% diection of tangent at internal points is 1/2 way between
% the direction of segments on each side of it
for i=2:(N-1)
    t1 = [x(i)-x(i-1); y(i)-y(i-1); z(i)-z(i-1)];
    t2 = [x(i+1)-x(i); y(i+1)-y(i); z(i+1)-z(i)];
    tangent(:,i) = (t1/norm(t1)+t2/norm(t2));
end

% tangent at last point is parallel to the last segment
tangent(:,N) = [x(N)-x(N-1); y(N)-y(N-1); z(N)-z(N-1)];
tangent(:,N) = tangent(:,N);


function u = unitperp2(tangent);

% unit perpendiculars to the plane containing the line
% segments on each side of each point

N = size(tangent,2);

% find the first pair of segments that are not parallel
conum = 1e6;   % condition number for parallel test
k=0;
for i=2:N
    if cond([tangent(:, (i-1):i) ones(3,1)])<conum   % segments not parallel
%    if tangent(:,i)'*tangent(:,i-1)/(norm(tangent(:,i))*norm(tangent(:,i-1)))<(1-1e-6)  % cos angle between segs > 1e-12
       k=i;
       break
   end
end
if k==0  % segments are parallel
    if cond([tangent(:,1) [0 0 1 ; 1 1 1]'])<conum
        t0 = [0 0 1]';     % choose unit along z if it is not parallel
    else
        t0 = [1 0 0]';     % otherwise choose unit along x
    end
else
    t0 = tangent(:,k);
end

% first point is a special case
u(:,1) = cross(tangent(:,1), t0);
u(:,1) = u(:,1)/norm(u(:,1));

for i=2:N
        if cond([tangent(:, (i-1):i) ones(3,1)])>conum  % segments parallel

%     if tangent(:,i)'*tangent(:,i-1)/(norm(tangent(:,i))*norm(tangent(:,i-1)))>(1-1e-6)  % seg i is parallel to previous
        u(:,i) = u(:,i-1);
    else
        u(:,i) = cross(tangent(:,i-1), tangent(:,i));
        u(:,i) = u(:,i)/norm(u(:,i)); 
    end
end

        
    
    
    
    
    
    
    