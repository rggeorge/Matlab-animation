function unhideall(h)

% function unhideall(h)
% unhide rigidbodies and all descendents
% h is a vector of handles of objects to unhide
% MGP June 2004/Oct 2005

for i=1:length(h)
    
    set(h(i), 'visible', 'on');
    c = uget(h(i), 'children');

    for i=1:length(c)
        unhideall(c(i));
    end
    
end