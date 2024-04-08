function [dfolders] = get_subfolders(top_folder)
% get the folder contents
 d = dir(top_folder);
% remove all files (isdir property is 0)
dfolders = d([d(:).isdir]) ;
% remove '.' and '..' 
 dfolders = dfolders(~ismember({dfolders(:).name},{'.','..'}));
end