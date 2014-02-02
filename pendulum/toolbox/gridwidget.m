function g=gridwidget(varargin)

% function g=gridwidget(property name/value pairs)
% translucent grid rigidbody in xy plane 
% 
% properties:
%     name      {'gridwidget'}
%     length    {10}
%     width     {4}
%     gridx     {1}  % grid spacing along x
%     gridy     {gridx}
%     colour    'g'
%     opacity   {.25}
%
% default 1x1 gridsize, green, 25% opaque
% Dyanimat Toolbox (c) Michael G Paulin 2005-2006

% defaults 
name = 'gridwidget';
gridlen = 10;
gridwid = 4;
gridx = 1;
colour = 'g';
opacity = 0.25;

N = length(varargin);
for i=1:2:N  % extract name-value pairs
    name  = varargin{i};
    value = varargin{i+1};
    if ~ischar(name) % fatal
        error('properties must be specified as property name/value pairs');
        return
    else
        switch name
            case 'name'
                name = value;
            case 'length'
                gridlen = value;
            case 'width'
                gridwid = value;
            case 'gridx'
                gridx = value;
            case 'gridy'
                gridy = value;
            case {'colour', 'color'}
                colour = value;
            case 'opacity'
                opacity = value;
            otherwise  % fatal
                error(['unrecognized stick property (' name ')']);
                return

        end
    end
end

if ~exist('gridy')
    gridy = gridx;
end


x = 0:gridx:gridlen;
y = (-gridwid/2):gridy:(gridwid/2);
s = surf(x, y, zeros(numel(y), numel(x)));
g = patch(surf2patch(s));
delete(s);
set(g, 'facecolor', colour, 'facealpha', opacity);
rigidbody(g, 'name', name, 'type', 'surface', 'edgecolor', 'k');





