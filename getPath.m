% ---------------------------------------- PATH ----------------------------------------

% return the path submodule
% containing utilities for dealing with paths, files and folders in
% the system environment
function path = getPath
    path.like = @like;
end

% finds files containing the 'query'
% if param 'where' is passed, search within the directory designated
% by 'where'. Otherwise, search within the current path.
function result = like(query,where)
    if nargin>1 % if param 'where' is provided
        files = dir(where);
    else files = dir; end
    for i=1:length(files)
        logic(1,i) = any(strfind(files(i).name,query));
    end
    result = files(logic);
end
