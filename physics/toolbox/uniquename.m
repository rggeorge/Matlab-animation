function name = uniquename(nameroot, type)

% function name = uniquename(nameroot, type)
% generate a unique variable or file name from root
% of the form 'namerootnnn' (counts up until finds an unused name)
% type is 'var'  = variable in workspace (default)
%         'file' = mat-file on current path
%         'rigidbody'
%
% (c) Michael G Paulin 2005

if nargin<2
    type = 'var';
end

if nargin<1
    nameroot =[];
end

if isempty(nameroot)
    nameroot = type;
end

switch type
    case 'file'

        dot = findstr('.', nameroot);
        if ~isempty(dot)
            nameroot = nameroot(1:(dot-1));
        end

        n = 0;
        name=[nameroot '.mat'];
        while evalin('base', [ 'exist(' '''' name '''' ','  '''' type '''' ');' ])
            nnn = ['00' num2str(n)];
            name = [nameroot nnn((end-2):end) '.mat'];
            n=n+1;
        end

    case 'var'

        n = 0;
        name=nameroot;
        while evalin('base', [ 'exist(' '''' name '''' ','  '''' type '''' ');' ])
            nnn = ['00' num2str(n)];
            name = [nameroot nnn((end-2):end)];
            n=n+1;
        end

    case 'rigidbody'

        % if name is not used, we are done
        if ~rigidbodyexists(nameroot)
            name = nameroot;
        else

            % otherwise extend using numbers
            for n = 0:999
                name = [nameroot num2str(n)];
                if ~rigidbodyexists(name)
                    break
                end
            end

        end

end


function exists = rigidbodyexists(name)

exists = false;
existingbody = findbody();
for i=1:length(existingbody)
    if strcmp(name, uget(existingbody(i), 'name'))
        exists = true;
        return
    end
end


