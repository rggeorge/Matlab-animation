function qsoln = animatedp(initialc, time, rad , masses)
% function handles = animatedp(initialc)
%
% animatedp creates a double pendulum consisting of two masses each on
% a rod, the second mass hanging from the first.  Initial considitions are 
% specified by the input 'initialc', which is a four-element vector of the 
% following form:
% initialc = [theta0   theta'0   phi0     phi'0]
% where theta is the angle between the first rod and the z-axis and phi is
% the angle between the first and second rod (parallel is zero).  Further 
% inputs are time, rod radii (two element vector), and masses (two element 
% vector), respectively. Other parameters can be changed within the 
% function in the first few lines or in makedp
%
% Ryan George
% COMO 401, Assignent Four

if ispc
    addpath([cd '\toolbox']); %add toolbox to directory
else
    addpath([cd '/toolbox']); %add toolbox to directory
end

if nargin <4
    masses = [5 5];
end
if nargin < 3
    rad = [10 10];
end
if nargin < 2
    time = 1.5;
end
if nargin < 1
    initialc = [pi/4 0 pi/3 0];
end

%parameters
P.time = time;
P.initialc = initialc(:)';
P.r1 = rad(1);
P.r2 = rad(2);
P.m1 = masses(1);
P.m2 = masses(2);
P.b1_mat = 'aluminium';
P.b2_mat = 'aluminium';

%create double pendulum
P = makedp(P);
drawnow;

%solve equations of motion. The input functions are notated in genode_fcn
soln = genodefcn(P, @dpmassmtx, @justzero, @Cforces, @justzero, @justzero, @neverzero, @neverzero);

%put solution in animatable form
dt = .01;
qsoln = [deval(soln{1}, 0:dt:P.time); 0:dt:P.time];

time_scale = .3; %time scaling;  <1 means slower
fr = 1; %counter records current frame 
tic

for t = 0:dt:P.time
    
    current_time = toc;
    while time_scale*current_time < t %while simluation time is ahead of real time
        current_time = toc; %update real time and wait
    end
    
    setq(P.handles.rod1, qsoln(1,fr)) %set first rod at angle
    setq(P.handles.rod2, qsoln(3,fr)) %set second rod at angle
    
    drawnow;
    fr = fr+1;
end