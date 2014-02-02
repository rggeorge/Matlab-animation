function m = material(materialtype)

% function mater = material(materialtype)
% material property data  structure
%  mater.density
%       .colour
%
% available materials:
%   {unspecified} : 1g/cm3
%   unitium       : 1g/cm3   [unit density material]
%   aluminium     : 2.7g/cm3, 
%   steel         : 7.8g/cm3, 
%   bone          : 1.8g/cm3  
%   enamel        : 2.5g/cm  (this is just a guess)
%   plastic       : 1.0g/cm3  (polyurethane)
%   wood          : 0.65g/cm3 (pine)
%   ether         : 0.0
%
% (c) Michael G Paulin 2005

if nargin<1
    materialtype = 'unspecified';
end

switch materialtype
    case 'unspecified'
        m.density = 0;
        m.colour  = [];
    case 'unitium'  % unit density material
        m.density = 1;
        m.colour = [1 1 1]; 
    case {'aluminum', 'aluminium'}
        m.density = 2.7;
        m.colour  = [1 1 1]*.8;
    case 'steel'
        m.density = 7.8;
        m.colour  = [1 1 1]*.5;
    case 'bone'
        m.density = 1.8;
        m.colour  = [.9 .9 .7];
    case 'enamel'
        m.density = 2.5;
        m.colour  = [.9 .9 1];
    case 'plastic'
        m.density = 1.0;
        m.colour  = [1 .2 .2];
    case 'wood'
        m.density = 0.65;
        m.colour  = [.75 .55 .2];
    case 'ether'
        m.density = 0;
        m.colour  = [.2 .2 1];
end


        