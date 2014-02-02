function nametags(handles, noecho)

% function nametags(handles, noecho)
% create workspace variables corresponding to object tags
% so you can refer to an object by using its tag as a variable name
% blanks in tags are replaced by underbars
% variable is not created if the tag field is not a valid variable name
% (except for blanks, which have been replaced by _'s )
% e.g. if the tag on gco is 'fred' then nametags(gco) creates a workspace
% variable fred whose value is the handle of gco.
% 
% if 'noecho' is not present then the names of the new variables are 
%     echoed to the workspace
% 
% Dyanimat Toolbox (c) Michael G Paulin 2006

if nargin<2
    disp('Creating new handles for each patch object from tags:')
end


for i=1:length(handles)
    name = get(handles(i), 'tag');
    if ~isempty(name)
        blank = find(name==' ');
        name(blank)='_';  % replace blanks with underbars
        try
        assignin('base', name, handles(i));
        if nargin<2
           disp(['   object ' num2str(i) ' is ' name])
        end
        catch
            disp([ name ' is not a valid variable name (no handle variable created)']);
        end
    end
end