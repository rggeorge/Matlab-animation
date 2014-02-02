function output = get_user_data(obj, prop)
%function output = get_user_data(obj, prop)
%get_user_data retrieves the property 'prop' from the given object's user
%data
%Ryan George 2009
%COMO 401

u = get(obj, 'userdata');

if nargin<2 %get_user_data(obj)
    output = u; %return all user data
else %get_user_data(obj, prop)
    try 
        output = u.(prop);
    catch        %if given property is not in userdata
        output = [];
    end
end