function cthru(h, alpha, edgecolor)

% function cthru(h, facealpha, edgecolor)
% see thru rigid body faces
%
% Dyanimat toolbox
% (c) Michael G Paulin 2004-2005

if nargin<3
    edgecolor = 'none';
end
if nargin<2
    alpha = 0;
end
c = uget(h, 'children');
switch get(h, 'type')
    case 'line'
        set(h, 'visible', 'off');
    case 'patch'
        set(h, 'facealpha', alpha);
        set(h, 'edgecolor', edgecolor);
end

for i=1:length(c)
    if uget(c(i), 'weld')
    cthru(c(i), alpha, edgecolor);
    end
end
