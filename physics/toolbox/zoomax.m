function zoomax(zoomfactor, axhandle)

% function zoomax(zoomfactor, axhandle)
% zoom axis limits, default axis is gca
% MGP Aug 2005

if nargin<2
    axhandle = gca;
end

set(axhandle, 'xlim', get(gca, 'xlim')*zoomfactor, 'ylim', get(gca, 'ylim')*zoomfactor, 'zlim', get(gca, 'zlim')*zoomfactor)
