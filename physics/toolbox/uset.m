function varargout = uset(h, property, value)

% function uset(h, property, value)
% create/set userdata field value
% Dyanimat Toolbox (c) Michael G Paulin 2004 - 2006
switch nargin
    case 1   % display userdata
        varargout{1} = get(h, 'userdata');
    case 2   % set userdata
        set(h, 'userdata', property);
        varargout{1} = property;
    case 3   % set/change userdata field value
        u = get(h, 'userdata');
        u.(property)=value;
%         eval(['u.' property '= value;'])
%         if strcmp(property,'name'),
%             set(h, 'tag', value);
%         end
        set(h, 'userdata', u);
end

