function camfreeze(az, el)

% function camfreeze(az,el)
% set all camera modes to manual
% MGP June 2004

set(gca, 'cameraviewanglemode', 'manual', ...
    'camerapositionmode', 'manual', ...
    'cameratargetmode', 'manual', ...
    'dataaspectratio', [1 1 1], ...
    'visible', 'off');

if nargin==1
    view(-35, 35);
elseif nargin==2
    view(az, el);  
end

drawnow

set(gca, 'cameraviewanglemode', 'manual', ...
    'camerapositionmode', 'manual', ...
    'cameratargetmode', 'manual', ...
    'xlimmode', 'manual', ...
    'ylimmode', 'manual', ...
    'zlimmode', 'manual', ...    
    'dataaspectratio', [1 1 1], ...
    'visible', 'off');

