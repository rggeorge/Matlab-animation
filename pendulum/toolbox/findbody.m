function [handle, name] = findbody(varargin)

% function [handle, name] = findbody('name', name, 'type', type)
% find rigidbody object by name and/or type
% types are: 'object' | 'axiswidget' | 'dummy' | 'surface'
%   if no argument given, finds all rigid bodies
%
% Dyanimat toolbox
% (c) Michael G Paulin 2004-2005

% find all rigidbody handles and names
handles = [];
names = {};
n=0;
c = allchild(gca);
for i=1:length(c)
    u = uget(c(i));
    if isfield(u, 'rigidbody')
        if u.rigidbody==true
            n = n+1;
            handles(n) = c(i);
            names{n}  = u.name;
        end
    end
end

if nargin==0
    % return all rigid body handles and names
    handle = handles';
    name = names';
else
    % return only objects with specified name and/or type
    % nb allows for multiple objects with same name and/or type
    if nargin>0
        handle = [];
        name = [];
        for i=1:nargin/2
            switch varargin{2*i-1}
                case 'name'
                    for j=1:length(handles)
                        if strcmp(names{j}, varargin{2*i})
                            handle = [handle handles(j)];
                            name = {name names{j}};
                        end
                    end
                case 'type'
                    for j=1:length(handles)
                        if strcmp(uget(handles(j), 'type'), varargin{2*i})
                            handle = [handle handles(j)];
                            name = {name names{j}};
                        end
                    end
                otherwise
                    error('unrecognized option');
            end
        end
    end
end


