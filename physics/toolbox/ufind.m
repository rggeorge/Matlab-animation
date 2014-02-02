function h = ufind(varargin)

% function h = ufind(name/value pairs)
% find objects in current (or specified) axes with specified userdata field values
% e.g. ufind('name', 'fred') finds all objects 
%      with a userdata field named 'name' whose value is 'fred'.
% also can specify 'axes', ax
%
% Dyanimat Toolbox (c) Michael G Paulin 2005/2006

% default axes
ax = gca;

% extract name/value pairs
N = nargin/2;
for i=1:N
    fieldname{i} = varargin{2*i-1};
    fieldvalue{i} = varargin{2*i};
    if strcmp(fieldname{i},'axes')
        ax = fieldvalue{i};
    end
end


% b = findbody;
b = get(ax, 'children');

h = [];
for i=1:length(b)

    u = get(b(i), 'userdata');

    oki = true;

    for j = 1:N

        if ~strcmp(fieldname{j}, 'axes')  % skip this (it is axes spec, not a field value to check)
            % does jth field exist and have the required value?
            okj = false;
            if isfield(u, fieldname{j})
                value = getfield(u, fieldname{j});
                if all(size(value)==size(fieldvalue{j}))
                    if all(value==fieldvalue{j})
                        okj = true;
                    end
                end
            end

            oki = oki*okj;  % oki stays true if jth field is ok
        end

    end

    if oki  % ith object matches all required fields
        h = [h b(i)];
    end

end
