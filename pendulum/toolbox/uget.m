function value = uget(h, property)

% function value = uget(h, property)
% get userdata field value
% returns NaN if h is not a field
% Dyanimat Toolbox (c) Michael G Paulin 2004-2006

u = get(h, 'userdata');
if nargin<2
    value = u;
else
    try
        value = u.(property);
    catch
        value = NaN;
    end
end