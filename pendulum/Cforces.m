function C = Cforces(P, q)
%function C = Cforces(P, q)
%
%Cforces.m calculates the inertial and conservative forces as given by 
%Legnani's equation for the system described by P and q 

N = length(q)/2; %number of state variables (number of mobile links)

C =  zeros(N,1);

for n = 1:N %for each mobile link (for each state variable)
    for k = 1:N %for each mobile link
            %sum this expression
            C(n) = trace(H_0(P,q,k)*J0(P,q,k)*(L0(P,q,n)')) + C(n);
    end
end