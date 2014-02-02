function P = makedp(P)
% function handles = makedp(P)
% makedp creates the double pendulum used by animatedp. Input is the data
% structure of parameters P.
%
% Ryan George
% COMO 401 Assignment Four

figure(1)
clf
%assign secondary parameters
base_l = .2;
base_r = .2;
base_m = 'steel';
rod_t = .1;
rod_m = 'aluminium';
b1_radius = .15*(P.m1)^(1/3);
b2_radius = .15*(P.m2)^(1/3);

%create and set anchor
anchor = pointystick('length', base_l, 'radius', base_r, 'material', base_m);
pose(anchor, r4([pi/2 pi/2 0 ], [0 0 base_l/2]));
rigidbody(anchor)
anchor_pose = r4([pi/2 0 0]);
pose(anchor, anchor_pose)
P.DH0{1} = anchor_pose; %store position
P.J{1} = zeros(4,4); %anchor will not add to dynamics of system
P.jointype{1} = 'welded';

%create first ball
b1 = geosphere(b1_radius);
rigidbody(b1, 'material', P.b1_mat)

%create first rod
rod1 = pointystick('length', P.r1, 'radius', rod_t, 'material', rod_m);
weld(rod1, b1)
pose(rod1, r4([pi/2 -pi/2 0],[0 0 -P.r1]));%pose link to 'base' pose
P.J{2} = uget(b1, 'inertia') + uget(rod1, 'inertia'); %get inertia matrices
P.jointype{2} = 'revolute';

%create second ball and rod; put in correct pose
b2 = geosphere(b2_radius);
rigidbody(b2, 'material', P.b2_mat)
rod2 = pointystick('length', P.r2, 'radius', rod_t, 'material', rod_m);
weld(rod2, b2)
pose(rod2, r4([pi/2 -pi/2 0],[0 0 -P.r1-P.r2]));
P.J{3} = uget(b2, 'inertia') + uget(rod2, 'inertia'); % get inertia
P.jointype{3} = 'revolute';

P.DH0{2} = pose(rod1, anchor); %store pose in parent frame when q=0
P.DH0{3} = pose(rod2, rod1);   %for both joints

%map from total linkage to mobile linkage. i.e. link 2 (rod1) is the second
%physical link, but the first mobile link, so P.tot2mobile(2) = 1
P.tot2mobile = [1 1 2];

%inverse map of P.tot2mobile
P.mobile2tot = [2 3];

dhlink(anchor, rod1, 'revolute') %link anchor and rod1 with revolute joint
dhlink(b1, rod2, 'revolute') %link rod2 and b1 with revolute joint

%set scene in initial conditions
setq(rod1, P.initialc(1))
setq(rod2, P.initialc(3))

%lighting and camera options
light;
lighting gouraud
daspect([1 1 1])
axis([-1 1 -1 1 -1 1]*(P.r1+P.r2+1))
cameratoolbar
camfreeze
campos([-1.3527  -51.6592    5.4315])
axis off
camzoom(3/((P.r1+P.r2)^(3/4)))

%create struct 'handles' to output for animation
P.handles.anchor = anchor;
P.handles.b1 = b1;
P.handles.b2 = b2;
P.handles.rod1 = rod1;
P.handles.rod2 = rod2;