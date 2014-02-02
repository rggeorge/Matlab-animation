function J = I2J(I)

% function J33 = I2J(I)
% 3x3 submatrix of pseudoinertia J from standard 3x3 inertia tensor (see Legnani)
% (see J2I.m)
%
% Dyanimat Toolbox (c) Michael G Paulin 2006

% J = (diag([I(2,2)+I(3,3), I(1,1)+I(3,3), I(1,1)+I(2,2)])+diag(diag(I)))/2-I;  

J = -I;                              % off-diagonals are sign-reversed
J(1,1) = (-I(1,1)+I(2,2)+I(3,3))/2;  % overwrite diagonals
J(2,2) = (-I(2,2)+I(1,1)+I(3,3))/2;
J(3,3) = (-I(3,3)+I(1,1)+I(2,2))/2;