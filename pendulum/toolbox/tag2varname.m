function tag = tag2varname(tag)

% function varname = tag2varname(tag)
% replace blanks in string with underbars 
% so the string can be used as a variable name
% 
% Dyanimat Toolbox (c) Michael G Paulin 2006

blank = find(tag==' ');
tag(blank)='_';  % replace blanks with underbars
