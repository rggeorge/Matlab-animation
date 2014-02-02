function set_user_data(obj, prop, value)

 switch nargin
     case 2
        set(obj, 'userdata', prop)
     case 3
        u = get(obj, 'userdata');
        eval(['u.' prop '=value;']);
        if strcmp(prop, 'name'),
            set(obj, 'tag', value);
        end
        set(obj, 'userdata' ,u);
 end
end
        