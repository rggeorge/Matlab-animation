function c = cspline(x,y,dy)

% function c = cspline(x,y,dy)
% coeffs of cubic poly in decreasing order (evaluate with polyval(c, x) )
% through x = [x0 x1] and y = [y0 y1] with endslopes dy = [dy0/dx dy1/dx]
% MGP August 2006

c = [x(1)^3 x(1)^2 x(1) 1; 3*x(1)^2 2*x(1) 1 0; x(2)^3 x(2)^2 x(2) 1; 3*x(2)^2 2*x(2) 1 0]\[y(1); dy(1); y(2); dy(2)];

