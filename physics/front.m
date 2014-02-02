function whichleg = front(whichleg)
%function leg = front(whichleg)
%
%Finds the 'front' leg that should be constrained in accordance with the
%rimless wheel in part 2. For a six-leg wheel with theta = pi/6 the numbering scheme is:
%
%           3\       /4
%             \     /
%              \   /
%               \ /
%      2 --------O-------- 5
%               / \
%              /   \
%             /     \
%           1/       \6
%
%Ryan George
%COMO 401, Assignment One

if numel(whichleg) == 2 %if the constraint is on for two legs
    if  whichleg(:) == [1; 2] %if legs 1 and 2 are on the ground
        whichleg = 1; %leg one is in front
    else
        whichleg = max(max(whichleg)); %the higher-number leg is in front
    end
end

%if more or less than two elements, leave whichleg unchanged