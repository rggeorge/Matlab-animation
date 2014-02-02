function unhide(h)

% function unhide(h)
% unhide rigidbodies
% h is a vector of handles of objects to unhide
% welded children are also unhidden
% MGP June 2004/Oct 2005

for i=1:length(h)
    set(h(i), 'visible', 'on');
    c = uget(h(i), 'children');

    for i=1:length(c)
        if uget(c(i), 'weld')
            set(c(i), 'visible', 'on');
        end
    end
end