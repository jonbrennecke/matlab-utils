% Matlab doesn't allow multiple functions to be accessed from a single
% *.m file.  A way around that is to return the functions as fields of a 
% 'struct'; this makes 'getUtils' function somewhat like a Python module.
function funs = getUtils
    funs.hexavigesimal = @hexavigesimal;
    funs.alphabetical_cast = @alphabetical_cast;
    funs.numerical_cast = @numerical_cast;
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
    number = numerical_cast(string(1)) * 26;
    for i=2:length(string)-1
        number = number * 26;
        number = number + (numerical_cast(string(i)) * 26);
    end
    number = number + numerical_cast(string(end));
end

% Convert numbers 0-25 to chars
function c = alphabetical_cast(number)
    c = char(97+str2num(sprintf('%i',number)));
end

% Convert chars to numbers 0-25
function number = numerical_cast(c)
    number = str2num(sprintf('%i',c)) - 97;
end
