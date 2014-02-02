function R = point2(a,b)

% function R3 = point2(a,b)
% 3x3 rotation matrix for rotating a to align with b
% 
% Michael G Paulin September 2006

u = cross(a,b);  % perpendicular to a and b
sintheta = norm(u)/(norm(a)*norm(b)); % sin of angle between a & b
costheta = a(:)'*b(:)/(norm(a)*norm(b)); % cos "
u = u/norm(u);  % unit rotation axis


A = [0 -u(3) u(2); u(3) 0 -u(1); -u(2) u(1) 0];  % skew matrix for u
R = eye(3) + sintheta*A + (1-costheta)*A^2;  % rodriguez formula