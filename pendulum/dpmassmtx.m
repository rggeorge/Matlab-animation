function mass_mtx = dpmassmtx(P,q)
%function mass_mtx = dpmassmtx(P,q)
%
%mass_mtx calculates the mass matrix of the physical system given by P and
%q using 4D kinematic methods.
%
%Ryan George
%COMO 401, Assignment Four

N = length(q)/2; %number of state variables (number of mobile links)

mass_mtx =  zeros(2,2); %start with zero mass matrix

for n = 1:N %for each row
    for m = 1:N %for each column
        for k = max(n,m):N %sum 4D kinematic expression from 'furthest link' on
            mass_mtx(n,m) = trace(L0(P,q,n)*J0(P,q,k)*(L0(P,q,m)'))+mass_mtx(n,m);
        end
    end
end