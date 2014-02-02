function connect(parent, child)

% function connect(parent, child)
% connect child (& its children) to parent
% (c) Michael G Paulin 2004

% reset child pose in (new) parent frame
uset(child, 'pose', pose(child, parent));

% make parent
uset(child, 'parent', parent);

% make child
sibs = uget(parent ,'children');
if ~any(sibs==child)
    uset(parent,'children', [sibs; child]);
end



