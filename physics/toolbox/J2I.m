function I = J2I(J)

% function I = J2I(J)
% Standard 3x3 inertia tensor I from 4x4 pseudoinertia J (see Legnani)
% (or from 3x3 submatrix of J).
% (see I2J.m)
%
% Dyanimat Toolbox (c) Michael G Paulin 2006


I = -J(1:3, 1:3);  % off-diagonals are sign-reversed
I(1,1) = J(2,2)+J(3,3);
I(2,2) = J(1,1)+J(3,3);
I(3,3) = J(1,1)+J(2,2);

% I = (diag([J(2,2)+J(3,3), J(1,1)+J(3,3), J(1,1)+J(2,2)])+diag(diag(I)))/2-I;  