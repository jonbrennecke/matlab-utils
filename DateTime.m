%
% DateTime object
%
% by @jonbrennecke / https://github.com/jonbrennecke
%`
% Released under the MIT license (see the accompanying LICENSE.txt)
%  
classdef DateTime

	properties
		
		year;
		month;
		day;
		hour;
		minute;
		micro;
		milli;

	end

	properties (Hidden, SetAccess = private, GetAccess = private)

		% Format Regular Expressions

		% Y/M/D,H:M:S AM|PM
		f1 = [
			'(?<month>0[1-9]|1[0-2])(.*?)' ... 				% numbers 01-12
			'(?<day>0[1-9]|1[0-9]|2[0-9]|3[0-1])(.*?)' ...	% numbers 01-31
			'(?<year>\d{4}|\d{2})(.*?)' ...					% group of 4 numbers | group of 2 numbers
			'(?<hour>0[1-9]|1[0-9]|2[0-4])(.*?)' ...		% numbers 01-24
			'(?<min>\d{2}|\d{1})(.*?)' ...					% group of 2 numbers | 1 number [0-9]
			'(?<sec>\d{2}|\d{1})(.*?)'...					% group of 2 numbers | 1 number [0-9]
			'(?<meridian>AM|PM)'	...						% AM | PM
		];

	end

	properties (SetAccess = private)

		format;

	end
	
	events
	end

	methods
		
		% Constructor
		function this = DateTime(str)
			if( exist('str') ) 

			% 	% regexp(str,this.ISO,'names')


			end
		end

		function setFormat(fstr)
			
		end

	end % methods

	methods (Static)
	end % static methods

end % XL