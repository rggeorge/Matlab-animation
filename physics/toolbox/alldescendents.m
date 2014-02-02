function d=alldescendents(parent)

% function d=alldescendents(parent)
% find all children and their children etc
%
% see descendents()
% 
% MGP July 2004

c = uget(parent, 'children');

d=[];
for i=1:length(c)
    d = [d; c(i); alldescendents(c(i))];
end

