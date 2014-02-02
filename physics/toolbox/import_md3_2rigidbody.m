function varargout = import_md3_2rigidbody(filename)

% function handles = import_md3_2rigidbody(filename)
% Imports md3 files exported from gmax into matlab as rigidbody objects
% with linkage data 
% (nb if you simply want to import objects to MATLAB as patch objects,
%     use import_md3_2patch).
% 
% objects must be identified by information in the gmax name field:
% syntax for type==link: <type> ' ' <name> : <materialname>
%                 joint: <type> ' ' <name> : <parentname> - <childname>
%                  weld: <type> ' ' <name> : <parentname> - <childname>
%                  base: <type> ' ' <name> : <materialname>
%                marker: <type> ' ' <name> : <bodysegmentname>
% e.g.
%    base hip: bone
%    link thigh: bone
%    link shin: bone
%    joint knee: thigh - shin
%    weld hipjoint: hip - thigh
%
% (see material.m)
%
% nb To assemble the objects into a rigid body linkage use dyanimat_assemble.m
%
% (c) Yerin Yoo, Michael G Paulin 2006

disp(sprintf('\n'));
disp('Importing rigidbodies from .md3 file')

% Processing the input md3 file!!
fid = fopen(filename,'rb'); % md3 is a binary file
if (fid==-1)
   error(['Error: Could not open ', filename]);
   return
end

% File header
fileID = fread(fid, 4, 'char'); % fileID must be IDP3
fileID = array2str(fileID);

% If the fileID is not IDP3 it's not a correct md3 file!!
if strcmp(fileID, 'IDP3')==0
    error('ERROR: Your input file is not a md3 file!');
    return
end
version = fread(fid, 1, 'int'); % version must be 15

filename = fread(fid, 68, 'char'); % gives entire path of where it's created  

numFrames = fread(fid, 1, 'int'); 
numTags = fread(fid, 1, 'int'); 
numMeshes = fread(fid, 1, 'int'); 
numMaxSkins = fread(fid, 1, 'int'); 

% offsets in bytes
startFrames = fread(fid, 1, 'int'); 
tagStart = fread(fid, 1, 'int'); 
meshStart = fread(fid, 1, 'int'); 
fileSize = fread(fid, 1, 'int'); % in bytes

% Taking the mesh information
% beware the cursor position!!!
meshOffset = meshStart;

for i=1:numMeshes
    %seek to find the start of the mesh
    fseek(fid, meshOffset, 'bof');
    
    %get the mesh header
    mesh(i).meshID = fread(fid, 4, 'char');
    mesh(i).meshID = array2str(mesh(i).meshID);
    mesh(i).meshName = fread(fid, 68, 'char');
    mesh(i).meshName = array2str(mesh(i).meshName);
    mesh(i).numMeshFrames = fread(fid, 1, 'int');
    mesh(i).numMeshSkins = fread(fid, 1, 'int');
    mesh(i).numVertices = fread(fid, 1, 'int');
    mesh(i).numFaces = fread(fid, 1, 'int');
    mesh(i).faceStart = fread(fid, 1, 'int');
    mesh(i).skinStart = fread(fid, 1, 'int');
    mesh(i).uvStart = fread(fid, 1, 'int');
    mesh(i).vertexStart = fread(fid, 1, 'int');
    mesh(i).meshSize = fread(fid, 1, 'int');
    
    % reading in the skin information
    mesh(i).skinName = fread(fid, 68, 'char');
    mesh(i).skinName = array2str(mesh(i).skinName);
    
    % Seek to find face data and read them!
    fseek(fid, meshOffset+mesh(i).faceStart, 'bof');
    if mesh(i).numFaces>0
        mesh(i).faces = fread(fid, [3, mesh(i).numFaces], 'int');
    end
    % Adding 1 to every entry to fit into MatLab data structure
    mesh(i).faces = mesh(i).faces' +1; 
    
    
    % Seek to find UV data and read them!
    fseek(fid, meshOffset+mesh(i).uvStart, 'bof');
    if mesh(i).numVertices>0
        mesh(i).uv = fread(fid, [2, mesh(i).numVertices], 'float');
    end
    mesh(i).uv = mesh(i).uv';
    
    % Seek to find the vertices and read them!
    fseek(fid, meshOffset+mesh(i).vertexStart, 'bof');
    if mesh(i).numVertices>0
        mesh(i).vertices = [];
        mesh(i).normals = [];
        for j=1:mesh(i).numVertices
            temp1 = fread(fid, [1,3], 'short') / 64;
            temp2 = fread(fid, [1,2], 'uchar');
            mesh(i).vertices = [mesh(i).vertices; temp1];
            mesh(i).normals = [mesh(i).normals; temp2];
            
        end
    end
    % increase the offset to read the next mesh!
    meshOffset = meshOffset + mesh(i).meshSize;
end

fclose(fid); % Dump the md3 file! :)

% make the meshes into rigidbody
handles = [];
disp('Bodies: ');
for i=1:numMeshes
    
    faces = mesh(i).faces;
    vertices = mesh(i).vertices;
    
    faces = makeanticlockwise(vertices, faces);
    faces = fixvertexorder(vertices, faces);
    
    
    % extract object description from tag
    blank = find(mesh(i).meshName==' '); 
    type  = mesh(i).meshName(1:(blank(1)-1));  % type is the token before the 1st blank 
    
    icolon = find(mesh(i).meshName==':');
    if isempty(icolon), icolon = numel(mesh(i).meshName)+1;end
    name = mesh(i).meshName((blank(1)+1):(icolon(1)-1)); % name is between type and 1st colon
   
    switch type
        case {'base', 'link'}
            materialname = mesh(i).meshName((icolon(1)+1):end);
            materialname=mydeblank(materialname, '');  % remove blanks from materialname
            childname = '';
            parentname = '';
            frame = 'body';
            ax = 'x';
        case {'joint', 'weld'}
            idash  = find(mesh(i).meshName=='-');
            parentname = mydeblank(mesh(i).meshName((icolon(1)+1):(idash(1)-1)));  % parentname is between ':' and '-'        
            childname  = mydeblank(mesh(i).meshName((idash(1)+1):end));            % childname is from '-' to end
            materialname = 'ether';
            frame = 'pointy';
            ax = 'z';
        case 'marker'
            childname  = mydeblank(mesh(i).meshName((icolon(1)+1):end));           % childname (body that marker is linked to) is from ':' to end
            parentname = '';
            frame = 'body';
            ax = 'x';
            materialname = 'ether';
        otherwise
            error('unrecognized object in MD3 file (help import_md3)');
    end
%     disp(name)
%     disp(materialname)
    h = patch('vertices', vertices, 'faces', faces, 'facecolor', [.3 .3 .3]);
    rigidbody(h, 'name', name, 'material', materialname, 'frame', frame, 'axis', ax, 'type', type);
    uset(h, 'childname', childname);
    uset(h, 'parentname', parentname);
    
    disp(['   ' name]);
    drawnow
    
    handles = [handles, h];   
end
disp([num2str(numel(handles)) ' bodies imported OK.']);
disp(sprintf('\n'));

varargout{1} = handles;

function strout = array2str(arr)
% function strout = array2str(arr)
% converts the nummeric array into a string
% discarding all the bullshit characters!!

    [maxLength, foo] = size(arr);
    
    k = 1;
    % search the string until it finds the first occurrence of 0
    while (arr(k)~=0)&&(k<maxLength)
        k = k+1;
    end
    % cut off the array so that it contains first lot of non-zero entries
    if k<maxLength
        arr = arr(1:k-1);
    end
    % convert the array into the string
    if maxLength==0 % array didn't contain anything
        strout = '';
    else
        strout = char(arr');
    end
 
function faces = fixvertexorder(vertices, faces)

[numfaces temp] = size(faces);

for m=2:2:numfaces
    
    prevface = faces(m-1,:);
    face = faces(m,:);
    
    faces(m,:) = [face(3) face(1) face(2)];
end
    
function faces = makeanticlockwise(vertices, faces)
% function faces = makeclockwise(vertices, faces)
% sets all faces to be ordered anti-clockwise.

[numfaces temp] = size(faces);

center = mean(vertices);

for m=1:numfaces
   f1 = faces(m,1);
   f2 = faces(m,2);
   f3 = faces(m,3);
   v1 = vertices(f1,:);
   v2 = vertices(f2,:);
   v3 = vertices(f3,:);
   
   a = v2-v1;
   b = v3-v1;   
   n = cross(a, b); 
   tocenter = center-v1; % vecter towards the centre of the object
   
   check = dot(n, tocenter);
   
   if check>=0 
       faces(m,2) = f3;
       faces(m,3) = f2;
   end 
   
end

