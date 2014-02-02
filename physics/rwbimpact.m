function postq = rwbimpact(P,oldq, whichleg)

J = [P.normal_fcn(P, oldq) 0]; %normal-to-impact vector
M = P.massmtx(P, oldq); %mass matrix at the time
K = -inv((J*inv(M)*(J')))*J*oldq(2:2:end); %constant, depends on situation

postq = zeros(size(oldq));
postq(1:2:end) = oldq(1:2:end); %positions stay the same

postq(2:2:end) = (M\(J'))*K + oldq(2:2:end); %post-impact velocities

al=P.alpha;
r = P.totalr;
[state whichleg] = rwbco(P, postq);
th = postq(5) + (front(whichleg)-1)*2*pi/P.nlegs;

udot = (postq(2)-r*cos(th)*postq(6))*cos(al) -(postq(4)+r*sin(th)*postq(6))*sin(al);

h = 1;