function weld(parent, child)

% function weld(parent, child)
% connect and weld rigidbodies
% welded bodies are treated as a single body 
% Dyanimat Toolbox (c) Michael G Paulin June 2004/October 2005

% reset child pose in (new) parent frame
uset(child, 'pose', pose(child, parent));

% make parent the parent of child
uset(child, 'parent', parent);

% add child to list of children
sibs = uget(parent,'children');
if ~any(sibs==child)
    uset(parent,'children', [sibs; child]);
end

% weld
uset(child, 'weld', 1);
