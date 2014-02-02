function namehandles(linkage)

% function namehandles(linkage)
% name the linkage handles in the workspace
% e.g. variable linkage.name will have value linkage.handle
% 
% see getlinkage
% 
% MGP October 2005

% create handle names in workspace
for i=1:length(linkage.name)
    name = linkage.name{i};
    blank = find(name==' ');
    name(blank)='_';  % replace blanks with underbars   
    assignin('base', name, linkage.handle(i))
end