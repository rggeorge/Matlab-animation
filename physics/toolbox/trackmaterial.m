function p = trackmaterial(tmaterial)

% function ptrack = trackmaterial(material)
% ground compliance and drag-friction parameters 
% outward normal force fn = d^n*(k+lambda*d') where d = vertex penetration 
% tangential drag-friction ft = -mu*vt*fn where vt = tangential vertex velocity
% 
% returns data structure
%  p.n
%   .k
%   .lambda
%   .mu
%   .color
%
% available materials (edit when you add a new material)
%   track       - running track; springy with high friction
%   concrete    % not implemented yet
%   grass       % not implemented yet 
%   mud         % not implemented yet
%   ice         % not implemented yet
%   snow        % not implemented yet
%   
% MGP Sept 2007

p.name = tmaterial;

switch tmaterial
    
    case 'track'
        p.k = 1e6;
        p.n = 2;
        p.lambda = 1e5;
        p.mu = 1e-1;
        p.color = [1 .2 .2]*.5;
        
    otherwise
        p = [];
        disp('unrecognized material');
end

       