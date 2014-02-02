function a = stringwobble(d, n, L)

% function a = stringwobble(d, n, L)
% what wave amplitude makes a string of length d span a distance L 
% with n periods of a sinusoidal wave?
% uses bisection with stringlength.m
% MGP August 2006

a0 = (d-L/2)/(L*n);        % amplitude of a square wave is an underestimate
a1 = sqrt(d^2-L^2)/(4*n);  % amplitude of a triangle wave is an overestimate

while (a1-a0)>L/1000
    
    nua = (a0+a1)/2;
    if stringlength(nua, n, L)>d
        a1 = nua;
    else
        a0 = nua;
    end
end

a = (a0+a1)/2;
