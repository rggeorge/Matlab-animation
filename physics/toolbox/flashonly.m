function flashonly(h)

% function flashonly(h)
% flash object to locate in scene
% see: flash, flashall
% MGP Nov 2004

for i = 1:4
    hideonly(h);
    drawnow
    pause(.1)
    unhideonly(h);
    drawnow
    pause(.2);
end