function flash(h)

% flash objects & welded children to locate in scene
% 
% see: flashonly, flashall
%
% MGP Nov 2004/Oct 2005

for i = 1:4
    hide(h);
    drawnow
    pause(.1)
    unhide(h);
    drawnow
    pause(.2);
end