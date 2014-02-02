function qpose = Qpose(q, jointype)
% function qpose = Qpose(q, jointype)
%
% calculates matrix DH(q), which is the pose matrix that maps a joint from
% position q = 0 to position q = q.
%
% Ryan George
% Assignment Four

switch jointype
    case 'revolute' %for revolute joint
        %pose matrix for rotation about parent's z-axis (equal to r4([0 q 0]);
        qpose = [cos(q)  -sin(q) 0 0; sin(q) cos(q) 0 0; 0 0 1 0; 0 0 0 1];
        
    case 'prismatic'
        %pose matrix for translation along parent's z-axis (equal to 
        %r4([0 0 0], [0 0 q]);
        qpose = diag([1 1 1 1]);
        qpose(3,4) = q;
        
    case 'welded'
        %no movement for welded joints
        qpose = eye(4);
end