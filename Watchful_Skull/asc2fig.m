function asc2fig(fname)

% function asc2fig(fname)
% load .ASC file exported from Esperient Creator into a figure window
% nb fname is a string of the form 'filename.asc'
% renders objects & assigns names in workspace
% MGP March 2009

clf

% open file
fid = fopen(fname, 'r');

Nobj = 0;

% read to end of file
while 1                    % loop forever
    aline = fgetl(fid);    % fgetl returns chars up to line feed
    if ~ischar(aline), break, end

    % does the line start with 'Named object:'
    if strncmp(aline, 'Named object:', 13)

        % found an object
        Nobj = Nobj+1;

        % get the object's name
        qpos = find(aline=='"');
        ObjName{Nobj} = aline((qpos(1)+1):(qpos(2)-1));
     
        % next line contains #vertices (token 3) & #faces (token 5)
        aline = fgetl(fid);
        tok = strread(aline, '%s');
        Nvtx(Nobj) = str2num(tok{3});
        Nfac(Nobj) = str2num(tok{5});
        
        disp([ObjName{Nobj} ', ' num2str(Nvtx(Nobj)) ', ' num2str(Nfac(Nobj))]);
        
        % read vertices to vertex array
        % token 3 is 'X:nnnn.nn' etc
        aline = fgetl(fid); % skip a line
        V{Nobj} = zeros(Nvtx(Nobj), 3);
        for i = 1:Nvtx(Nobj)
            aline = fgetl(fid);
            tok = strread(aline, '%s');
            V{Nobj}(i, :) = [   str2num(tok{3}(3:end)), 
                                str2num(tok{4}(3:end)),
                                str2num(tok{5}(3:end))     ];
        end
        
        % read face data to face array
        aline = fgetl(fid); % skip a line
        F{Nobj} = zeros(Nfac(Nobj), 3);
        for i=1:Nfac(Nobj)
            aline = fgetl(fid);
            tok = strread(aline, '%s');
            F{Nobj}(i,:) = [    str2num(tok{3}(3:end))+1, 
                                str2num(tok{4}(3:end))+1,
                                str2num(tok{5}(3:end))+1 ];
                            
            aline = fgetl(fid); aline = fgetl(fid);  % skip 2 lines
                       
                                
        end
            
        % draw the object, name it in userdata & workspace
        u = []; 
        u.name = ObjName{Nobj};
        Obj(Nobj) = patch('faces', F{Nobj}, 'vertices', V{Nobj}, ...
            'facecolor', rand(1,3), 'userdata', u );
        
        assignin('base', ObjName{Nobj}, Obj(Nobj));
        
        
    end


end

fclose(fid); % nb fclose('all') closes all files


