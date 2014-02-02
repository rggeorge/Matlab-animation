function R = r3(x,y,z, phi)

% function R = r3(...)
% 3D rotation matrix
% call syntax 1: [x y z], phi   - axis & angle             2 args
%             2: x, y, z, phi    - ditto, by component      4 args
%             3: R4              - 4x4 homogeneous matrix   1 arg
%             4: [theta psi phi] - euler angles             1 arg
%             4: theta, psi, phi - euler angles             3 args
%             5: quaternion      - (overloaded)
%             6: no argument, returns 3x3 identity
% nb: switching by nargin with no error checking
% MGP Dec 03/June 04

global EULERCONVENTION

if isempty(EULERCONVENTION)
    EULERCONVENTION = 'xzx';
end

switch nargin

    case 0  % no argument, return 3x3 identity
        R = eye(3);

    case 1  % either a 4x4 homogeneous matrix or 3 euler angles
        if all(size(x)==[4 4]) % 4x4 matrix
            R = x(1:3, 1:3);
        elseif all(size(x)==[3 3]) % 3x3 matrix  (required to simplify r4.m)
            R = x;
        else
            R = r3(x(1), x(2), x(3));   % call case 3
        end

    case 2 % axis + angle
        
        if y<eps
            R = eye(3);
        else
            R = r3(x(1), x(2), x(3), y);  % call case 4
        end

    case 3 % euler angles

        switch EULERCONVENTION
            case 'zyz'

                Rphi = [cos(z) -sin(z) 0; sin(z) cos(z) 0;  0  0 1];              % rotate around z
                Rpsi = [cos(y)  0 sin(y); 0 1 0 ;  -sin(y) 0  cos(y)];            % around y
                Rtheta = [cos(x) -sin(x) 0; sin(x)  cos(x) 0; 0  0  1];           % around z again
                R = Rtheta*Rpsi*Rphi;

            case 'xzx'

                Rphi = [1 0 0; 0 cos(z) -sin(z); 0 sin(z) cos(z)];         % rotate around x
                Rpsi = [cos(y) -sin(y) 0; sin(y) cos(y) 0;  0  0 1];       % around z
                Rtheta = [1 0 0; 0 cos(x) -sin(x); 0 sin(x) cos(x)];       % around x again
                R = Rtheta*Rpsi*Rphi;

            otherwise

                error(['Invalid EULERCONVENTION (global variable)']);
        end

    case 4 % axis + angle
        A = [0 -z y; z 0 -x; -y x 0]/norm([x y z]);
        R = eye(3) + sin(phi)*A + (1-cos(phi))*A^2;

end




