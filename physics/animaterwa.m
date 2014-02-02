function thsoln = animaterwa(initialc)
%function thsoln = animaterwa(initialc)
%
%animaterwa animates a rimless wheel confined to the ground surface 
%(Part 1). The equations of motion are solved by rwa.m Input is the initial
%conditions in the form:
%    animaterwa       (default)
%          or
%    animaterwa( theta0 )
%          or
%    animaterwa( [theta0 thetaprime0] )
%Parameters can be changed in the code.
%
%Ryan George
%COMO 401, Assignment 3

if ispc   %add toolbox to path
    addpath([cd '\toolbox'])
else
    addpath([cd '/toolbox'])
end

if nargin < 1 %if no input, set theta to default
    initialc = pi/30;
end

if numel(initialc) < 2 %if only theta given (or nothing) set thetaprime0=0
    initialc = [initialc; 0];
end
P.initialc = initialc;

%params
P.alpha = pi/9; %angle of slope

P.discr = 2.5; %disc radius (cm)
P.discth = 1; %disc thickness (cm)
P.discmat = 'aluminum'; %disc material
P.discprop = material(P.discmat); %retrieve material properties
P.discmass = P.discprop.density*(pi*(P.discr^2)*P.discth); %g

P.legr = .5; %radius of each leg (cylinder)
P.legl = 10; %length of each leg WITH CONE
P.legmat = 'aluminum'; %leg material
P.legprop = material(P.legmat);
P.nlegs = 6; %number of evenly-spaced legs

P.conel = 1; %length of cone at tip of foot
P.conemass = P.legprop.density*(pi*(P.legr^2)*P.conel/3);

P.legmass = P.legprop.density*(pi*(P.legr^2)*(P.legl-P.conel));

%total mass of rimless wheel
P.totalmass = P.discmass + P.nlegs*(P.legmass + P.conemass);
P.totalr = P.discr + P.legl; %distance from center of wheel to cone tip

%calculate inertia. P.inertia is ineria about tip of foot; P.centinertia is
%inertia about center of disc.
[P.inertia P.centinertia] = rwinertia(P);

P.time = 3; %total simulation time
time_scaling = .5; %scale of time (0<scale<inf); scale<1 refers to slowing 

P.distance = 200; %length of walking surface

try 
    [soln impact_times] = rwa(P); %numerically solve equations of motion
catch %in case simulation too short for impacts or theta0<=0
    soln = rwa(P);
    impact_times = [];
end

handles = makerw(P,1); %make rimless wheel

%piece together solution
dt = .01;
cur_time = 0;
total_time = P.time;
k = 1; %keeps track of which 'chunk' of solution we are on

while cur_time < total_time + dt; %while the solution is incomplete
    
    %find what the last time multiple of dt is in this solution chunk
    lastt = floor((soln{k}.x(end)/(dt)))*dt; 
    
    %truncate current time to 7 decimal places to avoid bugs
    cur_time = round((1e7)*cur_time)/(1e7);
    
    %form time lattice for this solution chunk
    cur_int = cur_time : dt : lastt;
    
    if numel(cur_int)>0 %if the current chunk has relevant information
        
        %add the current solution chunk's solution lattice onto the matrix
        %of solution vectors
        thsoln(1:3,round(cur_int/dt + 1)) = [deval(soln{k},cur_int); cur_int];
        
        cur_time = cur_int(end) + dt;  %update current time
    end
    k = k + 1; %advance counter
end

i = 1; %counter records current frame 


%these constant terms define the distance from the center of the disc at
%one impact and the center of the disc at the next impact.  Used to shift
%disc 'downhil' when theta is reset at impact.
xwheeltranslate = 2*P.totalr*sin(pi/P.nlegs)*cos(P.alpha);
ywheeltranslate = -2*P.totalr*sin(pi/P.nlegs)*sin(P.alpha);

tic

for t = 0:dt:total_time
    nimpacts = sum(impact_times < t);%number of impacts that have happened
    current_time = toc;
    while current_time*time_scaling < t %while simluation time is ahead of real time
        current_time = toc; %update real time and wait
    end
    
    %change theta; add multiples of xwheeltranslate and ywheeltranslate in
    %proportion to number of impacts that have occurred.
    pose(handles.disc, r4([-thsoln(1,i) 0 0], [0 xwheeltranslate ywheeltranslate]*nimpacts))
    
    drawnow;
    i = i+1;
end