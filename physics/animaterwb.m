function qsoln = animaterwb(initialc)
%function qsoln = animaterwb(initialc)
%
%animaterwb animates the rimless wheel not confined to the ground surface 
%(Part 2). The equations of motion are solved by genodefcn.m Input is the 
%initial conditions in the form:
%    animaterwb       (default)
%          or
%    animaterwb( theta0 )
%          or
%    animaterwb([x0 y0 theta0])
%          or
%    animaterwb([x0 xprime0 y0 yprime0 theta0 thetaprime0])
%Parameters can be changed in the code.
%
%Ryan George
%COMO 401, Assignment 3

if ispc   %add toolbox to path
    addpath([cd '\toolbox'])
else
    addpath([cd '/toolbox'])
end

if nargin < 1  %if no input
    initialc = pi/20; %set only theta
end

if numel(initialc) == 3 %if velocities not specified
    initialc = [initialc(1) 0 initialc(2) 0 initialc(3) 0]'; %default vel. 0
end

%params
P.alpha = pi/9; %angle of slope 

P.discr = 2.5; %disc radius (cm)
P.discth = 1; %disc thickness (cm)
P.discmat = 'aluminum';
P.discprop = material(P.discmat);
P.discmass = P.discprop.density*(pi*(P.discr^2)*P.discth);

P.legr = .5; %radius of leg (cm)
P.legl = 10; %length of leg (cm)
P.legmat = 'aluminum';
P.legprop = material(P.legmat);
P.legmass = P.legprop.density*(pi*(P.legr^2)*P.legl);
P.nlegs = 6; %number of evenly spaced legs

P.conel = 1; %length of tip of foot
P.conemass = P.legprop.density*(pi*(P.legr^2)*P.conel/3);

%total mass of rimless wheel
P.totalmass = P.discmass + P.nlegs*(P.legmass + P.conemass); 
P.totalr = P.discr + P.legl; %distance from center of wheel to cone tip

%calculate inertia. P.inertia is ineria about tip of foot; P.centinertia is
%inertia about center of disc.
[P.inertia P.centinertia] = rwinertia(P); 
P.mass_mtx = rwbmass_mtx(P); %calculate mass matrix

if numel(initialc) < 2 %animaterwb(theta0)
    xinit = P.totalr*sin(initialc); %calculate x,y coords to put wheel on
    yinit = P.totalr*cos(initialc); %the ground
    P.initialc = [xinit 0 yinit 0 initialc 0]; %set velocities to 0
else
    P.initialc = initialc;
end


P.time = 2; %total simulation time
time_scaling = .5; %scale of time (0<scale<inf); scale<1 refers to slowing
P.distance = 200; %length of walking surface
handles = makerw(P,2); %make wheel; return handles

%numerically approximate equations of motion using genodefcn
soln = genodefcn(P, @rwbmass_mtx, @rwbuncstr_fce, @rwbconstr_fce, @rwbnormal, @rwbco);


%put solution in animatable form
dt = .02;
qsoln = [deval(soln, 0:dt:P.time); 0:dt:P.time];

fr = 1; %counter records current frame 

tic

for t = 0:dt:P.time
    
    current_time = toc;
    while current_time*time_scaling < t %while simluation time is ahead of real time
        current_time = toc; %update real time and wait
    end
    
    %adjust theta, x, and y according to solution
    pose(handles.disc, r4([-qsoln(5,fr) 0 0], [0 qsoln(1,fr) qsoln(3,fr)]))
    
    drawnow;

    fr = fr+1;
end