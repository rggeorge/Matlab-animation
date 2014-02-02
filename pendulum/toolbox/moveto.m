function  moveto(object, pos, euler)

% function  moveto(object, pos, euler)
% move handle graphics object to specified position pos = [x y z]
% and orientation zxz-euler angles [ez2 ex ez1]

if nargin<3
    euler = [0 0 0];
end

u = get(object, 'userdata');
[m,n] = size(u.vertices);


Rz1 = [cos(euler(3)) -sin(euler(3)) 0;
       sin(euler(3)) cos(euler(3)) 0;
       0              0             1];
   
Rx = [1              0              0;
      0             cos(euler(2))   -sin(euler(2));
      0             sin(euler(2))   cos(euler(2))];
  
Rz3 = [cos(euler(1)) -sin(euler(1)) 0;
       sin(euler(1)) cos(euler(1)) 0;
       0              0             1];
   
% rotation matrix 
R = Rz3*Rx*Rz1;
  


set(object, 'vertices', (R*u.vertices')' + ones(m,1)*pos(:)')

