%
% An Object-Oriented approach to Matlab strings
%
classdef String

	properties (Hidden)
		value;
	end

	properties (SetAccess = private)
	end
	
	events   
	end

	methods

		% Constructor
		function this = String(value)
			% if class(value) == char, this.value = value; end
			this.value = value;
		end

		% split the string at 'delimiter'
		% @param { string } 'delimiter' - the delimiter
		function matches = split(this,delimiter)
			matches = textscan(this.value,'%s','delimiter',delimiter);
		    matches = matches{1,:};
		end

		% 
		function charAt(this)
		end

		% 
		function charCodeAt(this)
		end

		% 
		function concat(this)
		end

		% 
		function format(this)
		end

		% 
		function fromCharCode()
		end

		% 
		function indexOf()
		end

		% 
		function lastIndexOf()
		end

		% 
		function localeCompare()
		end

		% 
		function match()
		end

		% 
		function replace()
		end

		% 
		function search()
		end

		% 
		function slice()
		end

		% 
		function substr()
		end

		% 
		function toLocaleLowerCase()
		end

		% 
		function toLocaleUpperCase
		end

		% convert the string to lowercase
		% NOTE: does not modify this object
		% @return { String } this - the value of this String object converted to lowercase
		function this = lower(this)
			this.value = lower(this.value);
		end

		% convert the string to uppercase
		% NOTE: does not modify this object
		% @return { String } this - the value of this String object converted to uppercase
		function this = upper(this)
			this.value = upper(this.value);
		end

		% 
		function trim()
		end

		% ============================ Operators

		function newstr = plus(this,that)
			newstr = String([this.value that]);
		end

	end % methods

	methods (Static)
	end
end