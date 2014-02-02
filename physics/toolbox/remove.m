function remove(h)

% function remove(h)
% remove rigidbodies and welded children
%
% Dyanimat toolbox
% (c) Michael G Paulin 2004-2005

parent = uget(h, 'parent');
child = uget(h, 'children');

% delete welded children recursively
% and delete as parent of unwelded children
for i=1:length(child)
    if uget(child(i), 'weld')
    remove(child(i));
    else
        uset(child(i), 'parent', []);
    end
end

% remove from parent's children
pchild = uget(parent, 'children');
i = find(pchild~=h);
uset(parent, 'children', pchild(i));



delete(h);
