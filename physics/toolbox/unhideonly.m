function unhideonly(h, alpha)

% function unhideonly(h, alpha)
% unhide rigidbody
% MGP June 2004

c = uget(h, 'children');

set(h, 'visible', 'on');


for i=1:length(c)
    if uget(c(i), 'weld')
        unhideonly(c(i));
    end
end
