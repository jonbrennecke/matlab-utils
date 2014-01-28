
% ---------------------------------------- DEBUG ----------------------------------------

% return debugging submodule
function debug = getDebug
    debug.nargCmp = @nargCmp;
    debug.demote = @demote;
end

% check the number of arguments, and if unequal, display param 'msg' as an error
% <internal function>
function nargCmp(a,b,msg)
    if a~=b error(msg), end
end

% demote an error to a warning
function demote(err)
    msg = getReport(err);
    warning(msg)
end