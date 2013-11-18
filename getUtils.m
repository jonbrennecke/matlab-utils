% ---------------------------------------- HEADER ----------------------------------------
% 
% for a complete description, see http://github.com/jonbrennecke/matlab-utils
% 
% 
% 'getUtils' is a utility module of general purpose function collections. That is, it is a series of 
% organized 'submodules' of specific categories.
% 
% USAGE: call the module by 'utils = getUtils;'. Then functions/submodules may be called directly as 'utils.collection.function()'.
% 
% ----------------------------------------------------------------------------------------
% 
% Matlab doesn't allow multiple functions to be accessed from a single
% *.m file.  A way around that is to return the functions as fields of a 
% struct; this makes 'getUtils' function somewhat like a Python module.
function utils = getUtils
    % submodules
    utils.units = getUnits;
    utils.operators = getOperators;
    utils.exp = getExp;
    utils.os = getOS;
    utils.xl = getXL;
    utils.std = getOperators;
    utils.time = getTime;

    % methods
    utils.globalize = @globalize;
    % global as = operator TODO
end

% import all functions into the global workspace
% TODO
function import
end

% import a specific function from 'Utils' into the global workspace
function globalize(fun)
    nameparts = split(fun,'.');
%     eval(['assignin(''base'',''' nameparts{end} ''', ' fun ')']);
    evalin('base',['assignin(''base'',''' nameparts{end} ''', ' fun ')']);
end

% ---------------------------------------- OPERATORS ----------------------------------------

% return the operators submodule
function operators = getOperators
    % operators.vivify = @vivify; TODO
    operators.map = @map;
    operators.ternary = @ternary;
    operators.slice = @slice;
    operators.split = @split;
    operators.strsplit = @strsplit;
    operators.arraysplit = @arraysplit;
    operators.index = @index;
    operators.strip = @strip;
    % operators.hashmap = @hashmap; TODO
    operators.downsample = @downsample;
    operators.filter = @filter;
    operators.reverse = @reverse;
    operators.bkwd = @bkwd;
end

% reverse an array
% TODO reverse array in place
function iter = reverse(array)
    for i=abs(-length(array):-1)
        iter(length(array)-i+1)=array(i);
    end
end

% create an iterable sequence going backwards, faster than 'reverse'
function iter = bkwd(start,stop)
    iter = abs(-start:-stop);
end

% strip all instances of param 'substr' from str
function ret = strip(str,substr)
    chunks = split(str,substr);
    ret = '';
    for i=1:length(chunks)
        ret = [ ret char(chunks(i)) ];
    end
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
    matches = matches{1,:};
end

% split array at delimiter
function matches = arraysplit(array,delimiter)
    indx = [ 0 index(array,delimiter) length(array) ];
    for i=2:length(indx)
        matches{i-1,:} = array(indx(i-1)+1:indx(i));
    end
end

% return param 'array' as slices designated by param 'step'
% alternative syntax: slice also accept array input for param 'step', to slice at multiple locations
% designated by the elements of 'step'
function ret = slice(array,step)
    if numel(step)>1
        for i=1:length(step)-1
            ret{i,:} = array(step(i):step(i+1)-1);
        end
    else
        for i=0:floor(length(array)/step)-1
            ret(i+1,:) = array((i*step)+1:(i+1)*step);
        end
    end
end

% downsample an array by param 'step'
function ret = downsample(array,step)
    ret = mean(slice(array,step),2);
end

% implementation of an array mapping function (i.e. compare to Python Standard Lib 'map')
% apply param 'callback' to every element in param 'array' and return the result in an array
function ret = map(callback,array)
    ret = cell(0,numel(array));
    for i=1:numel(array)
        ret{i} = callback(array(i));
    end
end

% return a sequence consisting of those items from the esequence for which 
% param 'callback(array(i))' evalutes as true.
function ret = filter(callback,array)
    ret = [];
    for i=1:numel(array)
        if callback(array(i))
            ret(end+1) = array(i);
        end
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

% implementation of an autovivification function (i.e. compare to autovivification in Perl)
function vivify
end

% map every element of param 'array' to it's keyed element in param 'hash'
% return the resulting array 
function hashmap(array,hash)
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

% ---------------------------------------- EXP ----------------------------------------

% return 'experimental' submodule containing lesser used utilities and operators
function exp = getExp
    exp.piecewise = @piecewise;
    exp.bool = @bool;
    exp.logical_eval = @logical_eval;
end

% perform piecewise function on array
% Usage of this function currently looks like the following example:
% 
%   data = utils.exp.piecewise(array,{'x>300 && x<500','x>30 && x<50','x>15 && x<25','x>5 && x<15'},{1,10,20,40,0});
% 
% NOTE use of this function can be very slow for large arrays
% TODO accepts callbacks as cell of expressions, and evalute
function ret = piecewise(array,cases,callbacks)
    % compare the arguments
    nargCmp(nargin,3,'missing input arguments');
    if numel(cases) ~= numel(callbacks)-1
        error('callback functions array must have one element more than cases array.');
    end

    % predeclare the boolean expressions in param 'cases'
    bools = cell(length(cases));
    for i=1:length(cases)
        bools{i} = bool(cases{i});
    end

    % loop through 'array' and evalute 'cases'
    ret = zeros(length(array),1);
    for i=1:length(array)
        for j=1:length(cases)
            if bools{j}(array(i))
                ret(i,1) = callbacks{j};
                break;
            end
            % 'else'
            ret(i,1) = callbacks{end};
        end
    end
end

% Performs a logical indexing of an array with multiple cases.
% The elements in the array given by the indices returned from each logical indexing
% given in param 'cases' are assigned the values passed in param 'callbacks'
% TODO add support for anonymous functions or bool expressions to be evaluated for callbacks parameter.
function newarray = logical_eval(array,cases,callbacks)
    % compare the arguments
    nargCmp(nargin,3,'missing input arguments');
    if numel(cases) ~= numel(callbacks)
        error('cases array and callback functions array must be of the same size');
    end
    
    newarray = array; % duplicate 'array' as the modified array to be returned

    % use logical indexing to modify 'array'
    for i=1:length(cases)
        args = cell2mat(argnames(inline(cases{i})));
        eval(['newarray(' strrep(cases{i},args,'array') ') = callbacks{i};']);
    end
end

% to simplify passing anonymous functions as arguments, return param 'handle' as 
% a handle to an anonymous function that evaluates the boolean statement
% TODO (unfinished implementation) need to add support for multiple passed arguments
function handle = bool(statement)
    % define the parameters of the boolean expression
    args = cell2mat(argnames(inline(statement)));
    
    % create a function and return a handle to it
    function out = hndl(varargin)
        assignin('base',args,varargin{:});
        out = evalin('base',statement);
    end
    handle = @hndl;
end

% return a uniform neighborhood around each point passed in param 'points'
function out = neighborhood(array,points,width)
end

% ---------------------------------------- UNITS ----------------------------------------

% return unit and numerical conversion submodule
function units = getUnits
    units.base26 = @hexavigesimal;
    units.hexavigesimal = @hexavigesimal;
    units.alphabetical_cast = @alphabetical_cast;
    units.numerical_cast = @numerical_cast;
    units.binary = getBinary;
    units.sequence = @sequence;
    units.numdigits = @numdigits;
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

% converts param 'num' into a sequence of digits
function seq = sequence(num)
    for i=1:numdigits(num)
        seq(i) = round(mod(num,10^i)*(10*10^-i));
    end
end

% returns the number of digits in a number
function num = numdigits(num)
    if num<9, num = 1;
    else num=floor(log10(num)+1); end
end

% ---------------------------------------- BINARY ----------------------------------------

function bin = getBinary
    bin.and = @bin_and;
    bin.or = @bin_or;
    bin.xor = @bin_xor;
end

% bitwise AND
function bin = bin_and(a,b)
end

% bitwise OR
function bin = bin_or(a,b)
end

% bitwise XOR
function bin = bin_xor(a,b)
end

% ---------------------------------------- XL ----------------------------------------

% import the Excel module containing functions for working with Excel through an ActiveX connection
function xl = getXL
    xl.new = @newXL;
    xl.size = @sheetSize;
    xl.getRow = @getRow;
    xl.set = @setCells;
    xl.addSheet = @addSheet;
    xl.addSheets = @addSheets;
end

% create a new ActiveX connection to Excel
function [Excel,Workbooks,Sheets] = newXL
    Excel = actxserver('Excel.Application');
    set(Excel, 'Visible', 1);
    Workbooks = Excel.Workbooks;
    workbook.triggered = invoke(Workbooks, 'Add');
    Sheets = Excel.ActiveWorkBook.sheets;
    invoke(workbook.triggered,'Activate');
end

% add a single sheet to the active workbook
function sheet = addSheet(Excel,sheetname)
    Sheets = Excel.ActiveWorkBook.sheets;
    sheet = invoke(Sheets,'Add');
    invoke(sheet, 'Activate');
    sheet.name = sheetname;
end

% add multiple sheets to the active workbook
function sheets = addSheets(Excel,sheetnames)
    Sheets = Excel.ActiveWorkBook.sheets;
    for i=1:length(sheetnames)
        sheets{i} = addSheet(Excel,sheetnames{i});
    end
end

% return the size of a worksheet
function [numcols,numrows] = sheetSize(sheet)
    numcols = sheet.Range('A1').End('xlToRight').Column;
    numrows = sheet.Range('A1').End('xlDown').Row;
end

% return the row at param 'index'
function cells = getRow(sheet,index)
    [numcols,~] = size(sheet);
    cells = sheet.Range(strcat('A',num2str(index),':',upper(hexavigesimal(numcols)),num2str(index)));
end

% set the cell range starting at the point passed in param 'position'
function setCells(sheet,position,data)
    range = sheet.Range([ upper(hexavigesimal(position(1))) num2str(position(2)) ':'  upper(hexavigesimal(position(1) + size(data,2) - 1)) num2str(position(2) + size(data,1) -1) ]);
    set(range, 'Value', data);
end

% ---------------------------------------- TIME ----------------------------------------

function time = getTime
    time.datetime = @datetime;
end

% function this = datetime
%     % vars
%     this.day = 1;
%     this.year = 2;
%     % this.minute
%     % this.second
%     % this.millis
%     % this.micro
%     % this.date
%     % this.time

%     % methods
%     this. = @;

%     function 
%         disp('here');
%     end
    
% end

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
