function output = get_user_data(obj, prop)


u = get(obj, 'userdata');
if nargin<2
    output = u;
else
    try 
        output = u.(prop);
    catch
        output = [];
    end
end