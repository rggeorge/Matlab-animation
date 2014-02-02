function pose_matrix = r4(rotation, translation)
%function pose_matrix = r4(rotation, translation)
%r4 creates a pose matrix from the given xzx Euler angles and
%translation coordinates
%Ryan George
%COMO 401

if nargin < 2 || numel(translation) < 1 %r4(rotation) or r4(rotation, [])
    translation = [0 0 0];
elseif numel(rotation)<1 %r4([], translation)
    rotation = [0 0 0];
elseif numel(rotation)<2 %r4(rotation(1), translation)
    rotation = [rotation 0 0]; 
elseif numel(rotation)<3 %r4(rotation(1:2), translation)
    rotation = [rotation 0];
end

%create pose matrix from xzx Euler angles; put in translation coordinates
pose_matrix = [r3(rotation(1), rotation(2), rotation(3)) translation(:); 0 0 0 1];
end