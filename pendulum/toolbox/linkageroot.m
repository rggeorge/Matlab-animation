function root = linkageroot(link)

% function root = linkageroot(link)
% find the root object of a linkage
% 
% Dyanimat Toolbox (c) Michael G Paulin 2006

root = [];
currentobject = link;
while isempty(root)
    parentobject = parent(currentobject);
    if isempty(parentobject)
        root = currentobject;
    else
        currentobject = parentobject;
    end
end
