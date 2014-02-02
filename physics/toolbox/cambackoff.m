function cambackoff(factor)

% function cambackoff(factor)
% camera back off/approach current camera target (set by lookat)
% eg factor 2 doubles distance to target
%           0.5 halves it
%
% MGP Sept 2007

% find the camera target
bod = findbody;
for i=1:numel(bod)
    if uget(bod(i), 'istarget');
        break
    end
end
if i<numel(bod)
    tpos = position(bod(i));
else
    error('not looking at a rigidbody object (you must call lookat before using cambackoff)');
end

cpos = get(gca, 'cameraposition');   % current camera position
set(gca, 'cameraposition', tpos(:)+factor*(cpos(:)-tpos(:)));  % move camera out along line of sight



