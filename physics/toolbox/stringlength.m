function d = stringlength(a, n, L)

% function d = stringlength(a, n, L)
% how long is a piece of string?
% string is a sinusoid extending from 0 to L with n cycles of amplitude a
% calculated by elliptic function
% MGP August 2006

w = n/L;
alpha = 4*pi^2*a^2*w^2;
[k,e] = ellipke(alpha/(1+alpha));
d = 4*L*sqrt(1+alpha)*e/(2*pi);