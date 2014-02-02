function varargout = PatchProbe(Ax, DEBUG)

% function Object = PatchProbe(Ax)
% handles of patch objects along line of sight under currentpoint in current axes
%    Object.handle = object handles, in order along line of sight
%    Object.depth  = depth at which each object is encountered (distance from axis boundary plane)
%    Object.face   = index into object's 'faces' array for patch at entry point
%
% if nargin==0, Ax=gca
% if nargout==0, Object is appended to Ax userdata
%
% MGP July 2001
% Dec 2001 removed need to attach userdata to objects to be probed

if nargin==2
    DEBUG=1;
else
    DEBUG=0;
end
if nargin<1
    Ax = gca;
end

% line of sight from current point
p = get(Ax, 'currentpoint');
if DEBUG  % draw the probe line
    hold on
    Line = plot3(p(:,1), p(:,2)', p(:,3)', 'k');
    set(Line, 'tag', 'LINE');
end

% unit vector along line-of-sight
V = (p(2,:)-p(1,:))';    
V = V/norm(V);

% possible targets (objects for which the line enters the bounding box)
Object = findobj(gca, 'type', 'patch');
PossibleObject = [];
for i=1:length(Object)
    
    xrange = get(Object(i), 'xdata'); if isempty(xrange), xrange=0; end;
    yrange = get(Object(i), 'ydata'); if isempty(yrange), yrange=0; end;
    zrange = get(Object(i), 'zdata'); if isempty(zrange), zrange=0; end;
    
    xrange = [min(min(xrange)) max(max(xrange))];
    yrange = [min(min(yrange)) max(max(yrange))];
    zrange = [min(min(zrange)) max(max(zrange))];
    
    % vector to centre of ith object
    C = [mean(xrange) mean(yrange) mean(zrange)];
    C = (C-p(1,:))';
    
    %  point on line closest to box centre
    Q = p(1,:)' + V*sum(C.*V);
    
    % PossibleObject = handles of objects for which the probe line enters bounding box
    if Q(1)>=xrange(1) & Q(1)<=xrange(2) & Q(2)>=yrange(1) & Q(2)<=yrange(2) & Q(3)>=zrange(1) & Q(3)<=zrange(2)
        PossibleObject = [PossibleObject; Object(i)];
    end
    
end

% theta is angle between z-axis and V
theta = -acos(sum(V.*[0 0 1]'));

% R is perpendicular to V and Z
R = cross(V, [0 0 1]');


% rotation matrix 
cost = cos(theta);
sint = sin(theta);
ROT = [cost+R(1)^2*(1-cost) R(1)*R(2)*(1-cost)-R(3)*sint R(1)*R(3)*(1-cost)+R(2)*sint; ...
        R(1)*R(2)*(1-cost)+R(3)*sint cost+R(2)^2*(1-cost) R(2)*R(3)*(1-cost)-R(1)*sint; ...
        R(1)*R(3)*(1-cost)-R(2)*sint R(2)*R(3)*(1-cost)+R(1)*sint cost+R(3)^2*(1-cost)]';


Object.handle = [];
Object.depth =[];
Object.face =[];
Object.intersect = [];

for i = 1:length(PossibleObject)
    
    % transform vertex coords so that probe line is z-axis
    vertices = get(PossibleObject(i), 'vertices');
    [nvertices,junk] = size(vertices);
    newvertices = (ROT*(vertices - ones(nvertices, 1)*p(1,:))');
    
    % line can't intersect patches whose vertex x or y coords all have the same sign
    Faces = get(PossibleObject(i), 'faces');
    [nfaces, junk] = size(Faces);
    PossibleFace = find(abs(sum(sign(reshape(newvertices(1, Faces(:,:)'), 3, nfaces))))<3 & ...
        abs(sum(sign(reshape(newvertices(2, Faces(:,:)'), 3, nfaces))))<3);
    
    
    % search  the remaining possibilities
    for j=1:length(PossibleFace)
        
        % patch vertex coordinates
        x1 = newvertices(:, Faces(PossibleFace(j),1));
        x2 = newvertices(:, Faces(PossibleFace(j),2));
        x3 = newvertices(:, Faces(PossibleFace(j),3));
        
        % where z-axis intersects the plane of this patch
        try
            x0 = -inv([x2-x1 x3-x1 [0 0 -1]'])*x1;
        end
        x0 =  [0 0 x0(3)]';
        
        % is intersection point within the patch?
        v1 = cross(x0-x1, x2-x1);
        v2 = cross(x0-x2, x3-x2);
        v3 = cross(x0-x3, x1-x3);
        
        if DEBUG   % show the candidate patch 
            pa = patch('vertices', vertices, 'faces', Faces(PossibleFace(j),:), 'facecolor', 'r');
            pause(.1);
            delete(pa)
        end
        
        if abs(sum(sign([sum(v1.*V) sum(v2.*V) sum(v3.*V)])))==3  % v1,2,3 all pointing in same direction
            if DEBUG
                disp(['Encountered ' num2str(PossibleObject(i)) '=' get(PossibleObject(i), 'tag')]);
                disp(['Depth=' num2str(x0(3))]);
            end
            k=[];
            if ~isempty(Object.handle)
                k = find(PossibleObject(i)==Object.handle);    % have we already encountered this object?
            end
            
            if isempty(k)                                 % no
                Object.handle = [Object.handle ; PossibleObject(i)];
                Object.depth  = [Object.depth; x0(3)];
                Object.face =   [Object.face; PossibleFace(j)];
                Object.intersect = [Object.intersect; (inv(ROT)*x0 + p(1,:)')'];
            else                                          % yes
                if DEBUG
                    disp(['Previously encountered at depth ' num2str(Object.depth(k))]);
                end
                if x0(3)<Object.depth(k)                   % if the new encounter is shallower, replace the old
                    if DEBUG
                        disp('Replaced');
                    end
                    Object.handle(k) = PossibleObject(i);
                    Object.depth(k) = x0(3);
                    Object.face(k) = PossibleFace(j);
                    Object.intersect(k,:) = (inv(ROT)*x0 + p(1,:)')';
               end
            end
        end
    end
    
end

% sort by depth
[Object.depth, order] = sort(Object.depth);
Object.handle = Object.handle(order);
Object.face = Object.face(order);

if nargout==1
    varargout{1}=Object;
else
    u = get(Ax, 'userdata');
    u.Object = Object;
    set(Ax, 'userdata', u);
end
