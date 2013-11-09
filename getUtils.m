% ---------------------------------------- HEADER ----------------------------------------
% 
% 'getUtils' is a utility module of general purpose function collections. That is, it is a series of 
% organized 'submodules' of specific categories.
% 
% USAGE: call the module by 'utils = getUtils;'. Then functions/submodules may be called directly.
% 
% ----------------------------------------------------------------------------------------
% 
% Matlab doesn't allow multiple functions to be accessed from a single
% *.m file.  A way around that is to return the functions as fields of a 
% 'struct'; this makes 'getUtils' function somewhat like a Python module.
function utils = getUtils
    utils.units = getUnits;
    utils.operators = getOperators;
    utils.math = getMath;
    utils.os = getOS;
    % global as = operator
end

% import all functions into the global workspace
% TODO
function import
end

% ---------------------------------------- OPERATORS ----------------------------------------

% return the operators submodule
function operators = getOperators
    operators.vivify = @vivify;
    operators.map = @map;
    operators.ternary = @ternary;
    operators.slice = @slice;
    operators.split = @split;
    operators.strsplit = @strsplit;
    operators.arraysplit = @arraysplit;
    operators.index = @index;
end

% position(s) of 'delimiter' in array
function ret = index(array,delimiter)
    ret = find(array==delimiter);
end

% split string or array at delimiter
% all this does is call the appropriate functions (strsplit or arraysplit)
function matches = split(in,delimiter)
    if isstr(in) matches = strsplit(in,delimiter);
    else matches = arraysplit(in,delimiter); end
end

% split string at delimiter
function matches = strsplit(str,delimiter)
    matches = textscan(str,'%s','delimiter',{delimiter,'*'});
end

% split array at delimiter
function matches = arraysplit(array,delimiter)
    indx = [ 0 index(array,delimiter) length(array) ];
    for i=2:length(indx)
        matches{i-1,:} = array(indx(i-1)+1:indx(i));
    end
end

% return param 'array' as slices designated by param 'step'
% TODO accept array input for param 'step', to slice at multiple locations
function ret = slice(array,step)
    for i=0:floor(length(array)/step)-1
        ret(i+1,:) = array((i*step)+1:(i+1)*step);
    end
end

% implementation of an autovivification function (i.e. compare to autovivification in Perl)
function vivify
end

% implementation of an array mapping function (i.e. compare to Python Standard Lib 'map')
% apply param 'callback' to every element in param 'array' and return the result in an array
function ret = map(callback,array)
    ret = cell(0,numel(array));
    for i=1:numel(array)
        ret{i} = callback(array(i));
    end
end

% Implementation of a ternary operator
% if condition evaluates to 'true' return the result of callback 'a', 
% otherwise, return the result of callback 'a'
function ret = ternary(cond,a,b)
    if cond() 
        try ret = a(); disp('here'), return
        catch e
        end
    ret = b(); end
end

% ---------------------------------------- OS ----------------------------------------

% return the operating system submodule
function os = getOS
    os.path = getPath;
end

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

% ---------------------------------------- MATH ----------------------------------------

% return mathematics submodule
function math = getMath
    math.piecewise = @piecewise;
    math.bool = @bool;
end

% perform piecewise function on array
function ret = piecewise(array,cases,callbacks)
    nargCmp(nargin,3,'missing input arguments');
    if numel(cases) ~= numel(callbacks) 
        error('cases array and callback functions array must be of the same size');
    end
    for i=1:length(array)
        for j=1:length(cases)
            if cases{j}(array(i))
                ret(i,1) = callbacks{j}(array(i));
            end
        end
    end
end

% to simplify passing anonymous functions as arguments, return param 'handle' as 
% a handle to an anonymous function that evaluates the boolean statement
% TODO (unfinished implementation) need to add support for multiple passed arguments
function handle = bool(statement)
    % define the parameters of the boolean expression
    args = cell2mat(argnames(inline(statement)));
    
    % create a function and return a handle to it
    function hndl(varargin)
        assignin('base',args,varargin{:});
        evalin('base',statement);
    end
    handle = @hndl;
end

% ---------------------------------------- UNITS ----------------------------------------

% return unit and numerical conversion submodule
function units = getUnits
    units.base26 = @hexavigesimal;
    units.hexavigesimal = @hexavigesimal;
    units.alphabetical_cast = @alphabetical_cast;
    units.numerical_cast = @numerical_cast;
end

% Conversion to hexavigesimal (base 26)
% Note: what this actually returns is 'bijective base 26', 
% or 'base 26 without a zero'. I.e., using the digits from 'A'
% to 'Z' to represent 1-26 with no zero.
function result = hexavigesimal(in)
    if strcmp(class(in),'double')
        result = hexavigesimal_cast(in);
    elseif ischar(in)
        result = hexavigesimal_reverse(in);
    end
end

% Conversion from double to hexavigesimal (base 26)
function string = hexavigesimal_cast(number)
    number = number - 1;
    if number < 0
        warning('number must be greater than 0.');
        string = '';
        return;
    else
        quotient = floor(number/26);
        remainder = mod(number,26);
        string = '';
        while true  % since, matlab has no do-while loop
            if strcmp(string,'')
                string(end+1) = alphabetical_cast(remainder);
            else
                string(end+1) = alphabetical_cast(remainder-1);
            end
            if quotient==0
                break
            end
            remainder = mod(quotient,26);
            quotient = floor(quotient/26); 
        end
        string = fliplr(string);
    end
end

% Conversion from hexavigesimal (base 26) to double
function number = hexavigesimal_reverse(string)
    number = 0;
    for i=1:length(string)-1
        number = (number + numerical_cast(string(i)) + 1) * 26;
    end
    number = number + numerical_cast(string(end)) + 1;
end

% Convert numbers 0-25 to chars
function c = alphabetical_cast(number)
    c = char(97+str2num(sprintf('%i',number)));
end

% Convert chars to numbers 0-25
function number = numerical_cast(c)
    number = str2num(sprintf('%i',c)) - 97;
end

% ---------------------------------------- DEBUG ----------------------------------------

% return debugging submodule
function debug = getDebug
    debug.nargCmp = @nargCmp;
end

% check the number of arguments, and if unequal, display param 'msg' as an error
% <internal function>
function nargCmp(a,b,msg)
    if a~=b error(msg), end
end
