%
% DateTime object
%
% by @jonbrennecke / https://github.com/jonbrennecke
%`
% Released under the MIT license (see the accompanying LICENSE.txt)
%
% Modelled after the 'DateTime' class in PHP 5
% @see / http://www.php.net/manual/en/class.datetime.php
% 
%  
classdef DateTime

	% public properties
	properties
		
		year;
		month;
		day;
		hour;
		minute;
		micro;
		milli;

	end

	% private properties
	properties (SetAccess = private)

		current_format;

	end

	% Constants
	properties (Constant = true, Hidden, SetAccess = private, GetAccess = private)

		% Regular Expression base patterns

		month__ = '(?<month>0[1-9]|1[0-2])';			% numbers 01-12
		day__ = '(?<day>0[1-9]|1[0-9]|2[0-9]|3[0-1])';	% numbers 01-31
		year__ = '(?<year>\d{4}|\d{2})';				% group of 4 numbers | group of 2 numbers
		hour__ = '(?<hour>0[1-9]|1[0-9]|2[0-4])';		% numbers 01-24
		min__ = '(?<min>\d{2}|\d{1})';					% group of 2 numbers | 1 number [0-9]
		sec__ = '(?<sec>\d{2}|\d{1})';					% group of 2 numbers | 1 number [0-9]
		meridian__ ='(?<meridian>AM|am|PM|pm)'; 		% AM | PM

		% Regular Expressions constants for various DateTime formattings

		% M/D/Y | M-D-Y | M\D\Y | M D Y
		DEFAULT_DATE = [ ...
			DateTime.month__ '(\/|\\|\-|\s+?)' ...
			DateTime.day__ '(\/|\\|\-|\s+?)' ...
			DateTime.year__  ...
		];

		% H:M:S
		DEFAULT_TIME = [ ...
			DateTime.hour__  '(\:)' ...
			DateTime.min__   '(\:)' ...
			DateTime.sec__ ...
		];

		DEFAULT = [ ...
			DateTime.DEFAULT_DATE '(.*?)' ...
			DateTime.DEFAULT_TIME '(.*?)' ...	
			DateTime.meridian__ ...
		];

		% TODO implement the following (from PHP's DateTime spec)
		% DATE_ATOM; "Y-m-d\TH:i:sP"
		% DATE_COOKIE; "l, d-M-y H:i:s T"
		% DATE_ISO8601; "Y-m-d\TH:i:sO"
		% DATE_RFC822; "D, d M y H:i:s O"
		% DATE_RFC850; "l, d-M-y H:i:s T"
		% DATE_RFC1036; "D, d M y H:i:s O"
		% DATE_RFC1123; "D, d M Y H:i:s O"
		% DATE_RFC2822; "D, d M Y H:i:s O"
		% DATE_RFC3339; "Y-m-d\TH:i:sP"
		% DATE_RSS; "D, d M Y H:i:s O"
		% DATE_W3C; "Y-m-d\TH:i:sP" 

	end
	
	events
	end

	methods
		
		% Constructor
		function this = DateTime(str,fmt)
			if( exist('str') ) 

				disp( regexp(str,this.DEFAULT,'names') )

			end
		end

		function setFormat(fstr)
			
		end

	end % methods

	methods (Static)
	end % static methods

end % XL