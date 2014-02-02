function orbit(speed, norbits, ax)

% function orbit(speed, norbits, ax)
% orbit view of axes [gca] norbits [1] times
% speed in Hz (orbits/sec)
% MGP March 03

if nargin<1
    speed=1;
end

if nargin<2
    norbits=1;
end

if nargin<3
    ax = gca;
end

cpm = get(ax, 'camerapositionmode');
cvm = get(ax, 'cameraviewanglemode');
set(ax, 'camerapositionmode', 'manual', 'cameraviewanglemode', 'manual');

nsteps = ceil(64/speed);
degperstep = 360/nsteps;
x = 0;

for orbit=1:ceil(norbits)
    for step = 1:nsteps
        camorbit(ax, degperstep, 0); drawnow
        if (orbit+step/nsteps)>(norbits+1), break; end % allow partial orbits
        tic; while toc<(1/(nsteps*speed)), x=x+1; end 
    end
end

set(ax, 'camerapositionmode', cpm, 'cameraviewanglemode', cvm);
