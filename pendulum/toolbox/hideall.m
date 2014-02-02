function hideall(h)

% function hideall(h)
% hide rigidbodies and all descendents
% h is a vector of handles of objects to hide
% MGP June 2004/Oct 2005

for i=1:length(h)
    
    set(h(i), 'visible', 'off');
    c = uget(h(i), 'children');

    for i=1:length(c)
        hideall(c(i));
    end
    
end