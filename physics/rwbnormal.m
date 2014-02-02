function normal = rwbnormal(P,q)
%function normal = rwbnormal(P,q)
%
%rwbnormal returns the normal-to-ground vector for a (negative) slope with
%angle P.alpha to horizontal
%
%Ryan George
%COMO 401 Assignment 3

normal = [sin(P.alpha) cos(P.alpha)];