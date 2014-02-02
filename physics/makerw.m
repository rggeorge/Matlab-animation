function handles = makerw(P, origin_option)
%function handles = makerw(P, origin_option)
%
%makerw creates the rimless wheel specified by parameters in P. 
%'origin_options' takes value 1 to set the axes of the wheel at the tip of
%the foot, and value 2 to set the axes at the center of the wheel.
%
%Ryan George
%COMO 401, Assignment 3

figure(1)
clf
hold on

%create center disc to specs
disc = pointystick('length', P.discth, 'radius', P.discr, 'material', 'aluminium');
pose(disc, r4([0 0 0],[P.discth/2 0 0])) %center disc on origin
rigidbody(disc)

for k = 1:P.nlegs %for each leg
    leg(k) = pointystick('length', P.legl, 'radius', P.legr,...
        'material', 'aluminium', 'bottom', P.conel); %create leg
    pose(leg(k), r4([0 pi/2 0], [0 -P.discr 0]))%pose leg to be on side of disc
    weld(disc, leg(k)) %weld leg and disc
    
    %rotate disc by appropriate amount to make room for next leg
    pose(disc, r4([2*pi/P.nlegs*k 0 0])) 
end

if origin_option == 1 %if axes are to be set at tip of wheel
    pose(disc, r4([pi/P.nlegs 0 0], [0 0 P.totalr])) %pose disc vertical on ground
    rigidbody(disc) %reset coordinates
    pose(disc, r4([-P.initialc(1) 0 0])) %pose to initial conditions
elseif origin_option ==2 %if axes are to be set at center of wheel
    pose(disc, r4([pi/P.nlegs 0 0], [0 0 0])) %pose at origin, vertical
    rigidbody(disc) %reset coordinates
    %pose to initial conditions
    pose(disc, r4([-P.initialc(5) 0 0],[0 P.initialc(1) P.initialc(3)]))
end

[X,Y] = meshgrid(-2:.5:2, -1:.5:P.distance);
Z = -Y*tan(P.alpha);
surf(X,Y,Z) %create ground

handles.disc = disc; %store handles to be passes
handles.leg = leg;

%camera options
L=light;
lighting gouraud
daspect([1 1 1])
cameratoolbar
camfreeze
campos([425.0725 -260.6711  181.3813])
axis off
drawnow;