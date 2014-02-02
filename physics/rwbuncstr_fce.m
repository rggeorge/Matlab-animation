function force = rwbuncstr_fce(P,q,whichleg)
%function force = rwbuncstr_fce(P,q,whichleg)
%
%rwbunstr_fce calculates the unconstrained force upon the rimless wheel
%with parameters specified by P and state variables x, y, and theta 
%(reported in argument q). Input whichleg specifies which feet are on the
%ground.
%The force is composed of gravity, and spring-like force normal to the
%ground, and a drag/friction force.
%Adjstable parameters for spring force and friction force in first lines.
%
%Ryan George
%COMO 401, Assignment 3

%parameters for spring force:   F= ((v+eps)^p) * (c + lambda*vdot)
%where v is the distance of the foot underground
p = 4;
c = 1e5;
lambda = 6e4;
eps = 1;

mu_k = 5; %coefficient of kinetic friction between foot and ground
vel_cont = 2e2; %velocity contribution to drag

g =981; %cm/s^2
force_due_to_gravity = [0; -P.totalmass*g; 0];

al = P.alpha;
r = P.totalr;

x = q(1);
xdot = q(2);
z = q(3);
zdot = q(4);
thdot = q(6);

k=1;
base_th = q(5);

% if numel(whichleg)>0 %if one or more feet on the ground
%     %split up normal force between feet on the ground (one or two)
%     foot_normal_force = P.totalmass*g/(sin(al)*numel(whichleg));
% end

for n = whichleg %for each leg on the ground
    
  %spring force
    %express theta in terms of leg being calculated
    th = base_th + (n-1)*2*pi/P.nlegs; 
    
    %distance underground
    v = -(x-r*sin(th))*sin(al) - (z-r*cos(th))*cos(al);
    
    %velocity perpendicular to ground
    vdot = -(xdot-r*cos(th)*thdot)*sin(al) - (zdot+r*sin(th)*thdot)*cos(al);
    
    %velocity parallel to ground
    udot =  (xdot-r*cos(th)*thdot)*cos(al) - (zdot+r*sin(th)*thdot)*sin(al);
    
    %unit vector normal to current leg ('theta'-direction)
    theta_normal = [-cos(th); sin(th)];
    
    %unit vector parallel to current leg
    xz_normal = [sin(th); cos(th)];
    
    %magnitude of non-linear spring force
    mag_springforce = ((v+eps)^p)*(c + lambda*vdot);
    
    %spring force in (x,y) coordinates
    vector_springforce = mag_springforce*rwbnormal(P,q);
    
    %spring force that will contribute to theta velocity
    springforce_theta = dot(theta_normal, vector_springforce)*r;
    
    %spring force that will contribute to x and y velocities
    springforce_xz = dot(xz_normal, vector_springforce)*xz_normal;
    foot_spring_force(:,n) = [springforce_xz(1)  springforce_xz(2)  springforce_theta]';
    
  %friction force
    %magnitude of friction force
    %mag_fricforce = mu_k*foot_normal_force*v + udot*vel_cont;
    mag_fricforce = mu_k*mag_springforce;
    %drag force expressed in (x,y) coordinates
    vector_fricforce = mag_fricforce*[-cos(P.alpha); sin(P.alpha)];
    
    %component of friction force in 'theta' direction
    fricforce_theta = dot(theta_normal, vector_fricforce)*r;
    
    %component of friction force parallel to current leg
    fricforce_xz = dot(xz_normal, vector_fricforce)*xz_normal;

    foot_fric_force(:,n) = [fricforce_xz(1)  fricforce_xz(2) fricforce_theta]';

    k=k+1;
end

if numel(whichleg) == 0 %if no legs on ground
    addl_force = zeros(3,1); %zero additional force
else 
    %additional force is sum of spring force and drag force
    addl_force = sum(foot_spring_force, 2)+  sum(foot_fric_force, 2);
end

%sum of all forces
force = force_due_to_gravity + addl_force;
