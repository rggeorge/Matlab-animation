function output = r4(rotation, translation)
if nargin < 2 || numel(translation) < 1
    translation = [0 0 0];
elseif numel(rotation)<1
    rotation = [0 0 0];
elseif numel(rotation)<2
    rotation = [rotation 0 0];
elseif numel(rotation)<3
    rotation = [rotation 0];
end
output = [r3(rotation(1), rotation(2), rotation(3)) translation(:); 0 0 0 1];
end