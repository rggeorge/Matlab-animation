function axwidget(axlen, axwid)

% function axwidget(length)
% draw xyz axis lines, default length = 1, width = 2
% MGP March 2009
if nargin<2
    axwid = 2;
end
if nargin<1
    axlen = 1;
end

hold on
xax = plot3(axlen*[-1 1], [0 0 ], [0 0], 'r'); 
set(xax, 'linewidth', 2);
yax = plot3([0 0], axlen*[-1 1], [0 0], 'g');
set(yax, 'linewidth', 2);
zax = plot3([0 0], [0 0], axlen*[-1 1], 'b');
set(zax, 'linewidth', 2);