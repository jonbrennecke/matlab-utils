% ---------------------------------------- HEADER ----------------------------------------
% 
% for a complete description, see http://github.com/jonbrennecke/matlab-utils
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
    utils.math = getMath;
    utils.operators = getOperators;
    utils.exp = getExp;
    utils.os = getOS;
    utils.xl = getXL;
    utils.std = getOperators;
    utils.time = getTime;
    utils.debug = getDebug;

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
