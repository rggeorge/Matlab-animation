function set_user_data(obj, prop, value)
%function set_user_data(obj, prop, value)
%set_user_data sets obj's value of 'prop' to 'value' in its user data field

 switch nargin
     case 2 %set_user_data(obj, prop)
        set(obj, 'userdata', prop) %set all of userdata to 'prop'
     case 3 %set_user_data(obj, prop, value)
        u = get(obj, 'userdata');
        eval(['u.' prop '=value;']); %evaluate u.prop = value
        if strcmp(prop, 'name'),     %if the property is 'name'
            set(obj, 'tag', value);  %also set the object's tag to the name
        end
        set(obj, 'userdata' ,u);
 end
end
        