function link_pose = DHworldpose(P, q, link)
%function link_pose = DHworldpose(P, q, link)
%calculates a link's pose in the world frame using the DH convention
%
%Ryan George
%COMO 401, Assignment Four

link_pose = eye(4);%begin with world frame pose

for n = 1:link %for each link in succession
    %use pose composition to calculate the next link's pose in the world frame
    link_pose = link_pose*Qpose(q(2*P.tot2mobile(n)-1), P.jointype{n})*P.DH0{n};
end