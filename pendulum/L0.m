function L0 = L0(P, q, n)
%function L0 = L0(P, q, n)
%
% calculates L0, the inertia matrix of mobile link n in the world frame.
% Note that n is the link's position in the chain of mobile joints, and
% thus link n may not be the nth link in the physical chain. (mapped by 
% P.mobile2tot) 
% 
% Ryan George
% COMO 401, Assignment Four

%find which number PHYSICAL joint in chain by map in P.mobile2tot
link = P.mobile2tot(n);

switch P.jointype{link}
    
    %depending on joint type, use given velocity ratio matrix in own frame
    
    case 'revolute'    
        
        L = [0 -1 0 0;
             1  0 0 0;
             0  0 0 0;
             0  0 0 0];
         
    case 'prismatic'
        
        L = zeros(4,4);
        L(3,4) = 1;
        
    case 'welded'
        L = zeros(4,4);

end

%find pose of link in world frame
link_pose = DHworldpose(P, q, link);

%use pose transformation to express L in world frame
L0 = link_pose * L * inv(link_pose);