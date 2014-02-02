function J0 = J0(P, q, n)
%function J0 = J0(P, q, n)
%
% calculates J0, the inertia matrix of mobile link n in the world frame.
% Note that n is the link's position in the chain of mobile joints, and
% thus link n may not be the nth link in the physical chain. (mapped by 
% P.mobile2tot) 
% 
% Ryan George
% COMO 401, Assignment Four

%find which number PHYSICAL joint in chain by map in P.mobile2tot
link = P.mobile2tot(n);

%find pose of link in world frame
frame_pose = DHworldpose(P, q, link);

%use transformation rule to express J in world frame
J0 = frame_pose * P.J{link} * (frame_pose');