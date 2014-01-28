% ---------------------------------------- EXP ----------------------------------------

% return 'experimental' submodule containing lesser used utilities and operators
function exp = getExp
    exp.piecewise = @piecewise;
    exp.bool = @bool;
    exp.logical_eval = @logical_eval;
    exp.closest = @closest;
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

% return the element in array which is closest to 'number'
function [match, idx] = closest(array,number)
    array = sort(array);
    for i=1:length(array)
        if array(i)>=number
            if i-1
                dif = abs(number-array(i-1:i));
                idx = i-2 + find(dif==min(dif)); 
                match = array(idx); return;
            else
                match = array(i);
                idx = i;
                return; 
            end
        end       
    end
end