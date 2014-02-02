function hide(h)

% function hide(h)
% hide rigidbody (and welded children)
% h is a vector of handles 
% MGP June 2004/Oct 2005

for i=1:length(h)
    set(h(i), 'visible', 'off');
    c = uget(h(i), 'children');

    for i=1:length(c)
        if uget(c(i), 'weld')
            set(c(i), 'visible', 'off');
        end
    end
end