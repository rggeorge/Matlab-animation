function H_0 = H_0(P,q,k)
%function H_0 = H_0(P,q,k)
%
%calculates H_0, the acceleration of the kth moving link, when q_k is not
%accelerating. Note: link 'k' is the kth mobile link

%Ryan George
%COMO 401, Assignment Four

qdot = q(2:2:end);

centripetal = zeros(4,4);
%calculate acceleration due to centripetal forces
for n = 1:k %for each link before link k
    centripetal = (L0(P,q,n)^2)*(qdot(n)^2) + centripetal;
end

%calculate acceleration due to coriolis effect
coriolis = zeros(4,4);
for c = 2:k %for links 2 and on
    for j = 1:c-1 %for each link before given link
        coriolis = L0(P,q,j)*L0(P,q,c)*qdot(c)*qdot(j) + coriolis;
    end
end

%add gravity
grav = zeros(4,4);
grav(3,4) = -981; %cm/s^2


%sum all sources of acceleration
H_0 = centripetal + 2*coriolis + grav;