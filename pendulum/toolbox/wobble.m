function wobble(link, qmax, nrep, speak)

% function wobble(link, qmax, n, speak)
% wobble a list of dh links thru +/- qmax n times around current pose
% default qmax is pi/8 for revolute joint 
% or 10% of next physical link length for prismatic joint
% repeated 2x
%
% speak echos the link name to the workspace
% as each link is wobbled
%
% Dyanimat toolbox
% (c) Michael G Paulin 2005

% get link handles from data structure
if isstruct(link)
    link = link.handle;
end

if nargin>3
    speak = true;
else
    speak = false;
end
if nargin<3
    nrep = 2;
end
if isempty(nrep)
    nrep=2;
end
if nargin<2
    qmax = zeros(size(link));
end
if isempty(qmax)
    qmax = zeros(size(link));
end    


N = length(link);
if length(qmax)<N
    error('specify qmax for each link');
end
    

steps = 5;

for i=1:N
    
    q0 = setq(link(i));
    
    % echo link name to workspace
    if speak
        disp(uget(link(i), 'name'));
    end
    
    % compute qmax if not given for this link
    if qmax(i)==0
    switch uget(link(i), 'jointype')
        case 'prismatic'
            qmax(i) = d2child(link(i))/10;
        case 'revolute'
            qmax(i) = pi/20;
    end
    end
    
    % wobble the link
    for j=1:nrep
        for k = [1:steps (steps-1):-1:-steps (1-steps):0]
            setq(link(i), q0+qmax(i)*k/10);
            drawnow
        end
    end

end

function d = d2child(child)

% distance to first child that is a nonzero distance away

P = pose(child);
d = norm(P(1:3,4));

if d<1e-6
    c = children(child);
    for i=1:length(c)
        d = d2child(c(i));
    end
end




