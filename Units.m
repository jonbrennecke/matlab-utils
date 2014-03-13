%
% An object-oriented handler for various units and numerical conversions
%
% by @jonbrennecke / https://github.com/jonbrennecke
%
% Released under the MIT license (see the accompanying LICENSE.txt)
%  
classdef Units

	properties (Hidden)
	end

	properties (SetAccess = private)
	end
	
	events   
	end

	methods

		function this = Units
			% this class is mostly just a container for various functions (i.e. a namespace)
			% with no properties to initialize as of now
		end


	end % methods

	methods (Static)

		% Conversion to hexavigesimal (base 26)
		% Note: what this actually returns is 'bijective base 26', 
		% or 'base 26 without a zero'. I.e., using the digits from 'A'
		% to 'Z' to represent 1-26 with no zero.
		function result = hexavigesimal(in)
		    if strcmp( class(in),'double' )
		        result = Units.hexavigesimal_cast(in);
		    elseif ischar(in)
		        result = Units.hexavigesimal_reverse(in);
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
		                string(end+1) = Units.alphabetical_cast(remainder);
		            else
		                string(end+1) = Units.alphabetical_cast(remainder-1);
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
			string = lower(string);
		    number = 0;
		    for i=1:length(string)-1
		        number = (number + Units.numerical_cast(string(i)) + 1) * 26;
		    end
		    number = number + Units.numerical_cast(string(end)) + 1;
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
		    else num = floor(log10(num)+1); end
		end

		function result = base26(in)
			result = Units.hexavigesimal(in);
		end

	end % static methods

end % XL