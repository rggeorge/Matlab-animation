function varargout = setq(link, q)

% function q = setq(link,q)
% set/get joint variable of Denavit-Hartenberg linkage
% link is a vector of link handles, or a data structure 
% built by dyanalyze.m
% q is the vector of required joint variable values
% Dyanimat Toolbox (c) Michael G Paulin 2004/2005/2006

% get link handles from data structure
if isstruct(link)
    link = link.handle;
end

pose0 = uget(link, 'pose0');
if nargin==2
    for i=1:length(link)
        pose0 = uget(link(i), 'pose0');
        switch uget(link(i), 'jointype')
            case 'revolute'
                pose(link(i), r4([0 q(i) 0])*pose0);
            case 'prismatic'
                pose(link(i), r4([0 0 0], [0 0 q(i)])*pose0);
        end
        uset(link(i), 'q', q(i));
    end
else
    for i=1:length(link)
        q(i) = uget(link(i), 'q');
    end
end

if nargout>0
    varargout{1} = q;
end