function [state whichleg] = rwbco(P, q)
%function [state whichleg] = rwbco(P, q)
%
%rwbco determines if any feet of the rimless wheel are on the ground, and 
%if so, which feet they are
%
%Ryan George
%COMO 401 Assignment 3

base_th = q(5);%theta of leg one

for n = 1 : P.nlegs %for each leg
    
    %calculate theta to be expressed in terms of the current leg
    th = base_th + (n-1)*2*pi/P.nlegs;
    
    %calulate x and y coordinates of tip of foot
    x1 =  q(1) - P.totalr*sin(th);
    y1 =  q(3) - P.totalr*cos(th);
    
    %determine if current foot is under ground given by equation  y = -tan(alpha)*x
    st(n)= -tan(P.alpha)*x1 > y1;
end

%dectect any feet under the ground
state = any(st);

%determine which feet are under the ground
whichleg = find(st);