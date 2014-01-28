% ---------------------------------------- OS ----------------------------------------

% return the operating system submodule
function os = getOS
    os.path = getPath;
    os.open = @open_file;
end

% open a file and return its contents as char arrays delimited by newlines
function text = open_file(filename)
    fid = fopen(filename);
    content = fread(fid,'*char');
    text = split(content,'\n');
end