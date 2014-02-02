function R = r4(rot, pos)

% function R = r4(rot, pos)
% 4x4 homogenous rototranslation/pose matrix
% call syntax 1: R3, [x y z]                 - 3x3 rotation matrix + position
%             2: [theta psi phi], [x y z]    - xzx-euler angles + position
%             3: q, [x y z]                  - quaternion + position
% (the obvious) defaults are used if an argument is empty or missing
% MGP June 2004

if nargin<2
    pos = [0 0 0]';
end
if nargin==0
    R = eye(4);
    return
end
if isempty(rot)
    R = eye(4);
    return
end

if all(size(rot)==[4 4])
    R = rot;
else
    R = [r3(rot) pos(:); 0 0 0 1];
end


    
    