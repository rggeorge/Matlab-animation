function mass_mtx = rwbmass_mtx(P,q)
%function mass_mtx = rwbmass_mtx(P,q)
%
%rwbmass_mtx calculates mass matrix for rimless wheel with parameters 
%specified in P and described by state variables x, y, and theta
%
%Ryan George
%COMO 401, Assignment 3

mass_mtx = [P.totalmass 0 0; 0 P.totalmass 0; 0 0 P.centinertia];