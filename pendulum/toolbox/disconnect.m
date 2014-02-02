function disconnect(parent, child)

% function disconnect(parent, child)
% disconnect rigidbodies
% MGP June 2004

% child pose in world frame (its new parent)
uset(child, 'pose', pose(child, []));

% make child an orphan
uset(child, 'parent', []);
uset(child, 'weld', 0);

% remove child
c = uget(parent, 'children');
i = find(c==child);
if ~isempty(i)
    c = [c(1:(i-1)); c((i+1):end)];
    if isempty(c), c=[]; end  % seems redundant, huh? it's not. Trust me.
    uset(parent, 'children', c);
end

    