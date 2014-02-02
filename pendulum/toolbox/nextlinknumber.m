function inext = nextlinknumber(link)

% function i = biggestlinknumber(link)
% find the next available link number for a linkage
% (biggest existing link number +1, among descendents of link's root)
%
% Dyanimat Toolbox (c) Michael G Paulin 2006

inext = 1; % link 1 is the root, so first available link # is 2
d = alldescendents(linkageroot(link));
for i=1:length(d)
    u = uget(d(i));
    if isfield(u, 'iq')
        if u.iq>inext, inext=u.iq; end
    end
end
inext = inext+1;
        