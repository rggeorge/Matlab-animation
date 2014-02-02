function flashall(h)

% function flashall(h)
% flash biot graphics object on-off (to locate in scene)
% & descendents
% MGP Nov 2004

for i = 1:4
    hideall(h);
    drawnow
    pause(.1)
    unhideall(h);
    drawnow
    pause(.2);
end