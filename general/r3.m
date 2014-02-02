function output = r3(psi, phi, theta)

% function output = r3(psi, phi, theta)
% 3x3 rotation matrix from xzx Euler angles
%

Rpsix = [cos(psi) -sin(psi) 0; sin(psi) cos(psi) 0; 0 0 1];
Rphiz = [1 0 0; 0 cos(phi) -sin(phi); 0 sin(phi) cos(phi)];
Rthetax = [cos(theta) -sin(theta) 0; sin(theta) cos(theta) 0; 0 0 1];

output = Rthetax*Rphiz*Rpsix;