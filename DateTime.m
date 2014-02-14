%
% DateTime object
%
% created by @jonbrennecke / https://github.com/jonbrennecke
%
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
		second;
		micro;
		milli;
		epoch;

		format;

	end

	% Constants
	properties (Constant = true, Hidden, SetAccess = private, GetAccess = private)

		% ==============================================================
		% Regular Expression base patterns
		% ==============================================================

		month__ = '(?<month>0[1-9]|1[0-2])';			% numbers 01-12
		day__ = '(?<day>0[1-9]|1[0-9]|2[0-9]|3[0-1])';	% numbers 01-31
		year__ = '(?<year>\d{4}|\d{2})';				% group of 4 numbers | group of 2 numbers
		hour__ = '(?<hour>0[0-9]|1[0-9]|2[0-4])';		% numbers 00-23
		min__ = '(?<min>\d{2}|\d{1})';					% group of 2 numbers | 1 number [0-9]
		sec__ = '(?<sec>\d{2}|\d{1})';					% group of 2 numbers | 1 number [0-9]
		meridian__ ='(?<meridian>AM|am|PM|pm)'; 		% AM | PM

		% matches M/D/Y | M-D-Y | M\D\Y | M D Y
		DEFAULT_DATE = [ ...
			DateTime.month__ '(\/|\\|\-|\s+?)' ...
			DateTime.day__ '(\/|\\|\-|\s+?)' ...
			DateTime.year__  ...
		];

		% matches H:M:S
		DEFAULT_TIME = [ ...
			DateTime.hour__  '(\:)' ...
			DateTime.min__   '(\:)' ...
			DateTime.sec__ ...
		];

		% ==============================================================
		% Regular Expressions constants for various DateTime formattings
		% ==============================================================

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
		% @param { char } 'str' - string representation of a DateTime object
		% @param { char } 'fmt' - string representation of a DateTime format
		function this = DateTime(str,fmt)

			% if no formatting string is provided, set the format to DEFAULT
			if( ~exist('fmt') )
				this.format = 'DEFAULT';
			end

			if( exist('str') ) 

				matches = regexp(str,eval(['this.' this.format ]),'names');

				if( class(matches) ~= 'struct' ) % failed to match
					
					% TODO

				else % matched

					% TODO factor meridian into calculation, convert to military time
					
					this.month = str2num( matches.month );
					this.day = str2num( matches.day );
					this.year = str2num( matches.year );
					this.hour = str2num( matches.hour );
					this.minute = str2num( matches.min );
					this.second = str2num( matches.sec );

				end
			end

		end % Constructor

		% set the format string
		% @param { char } 'fmt' - string representation of a DateTime format
		function setFormat(this,fmt)
			this.format = fmt;
		end

		% 
		function this = set(this)

		end

		% @return { char } 'str' - string representation of this object
		function str = toString(this)
			str = [ ... 
				sprintf( '%02d', this.month ) '/' 		...
				sprintf( '%02d', this.day ) '/' 		...
				sprintf( '%04d', this.year ) ','		...
				sprintf( '%02d', this.hour ) ':' 		...
				sprintf( '%02d', this.minute ) ':' 		...
				sprintf( '%02d', this.second ) ' AM'	...
			];
		end

		% return as a 32-bit integer in Unix time (seconds since Jan. 1st 1970 00:00:00 )
		function epoch = toEpoch(this)
			% TODO fix leap year calculation
			% currently just using 11, (leap year days added 1970-2013)
			epoch = ( this.year - 1970 ) * 365 + ( 11 ); % number of days since unix epoch + days added by leapyears
			epoch = ( epoch + this.m2d(this.month,this.day) ) * 86400; % plus number of days into current year, converted to seconds
			epoch = epoch + ( ( this.hour * 60 + this.minute ) * 60 + this.second ); % plus hour, min, sec offset from time-of-day
		end

		% convert epoch time to month, day, year, hour, minute, second
		function fromEpoch(this,epoch)
		end

		% compare with another DateTime object
		% @param { DateTime } 'tOther' - object to compare with
		% @return { int } tDelta - number of seconds between DateTime objects
		function tDelta = cmp(this,tOther)
			tDelta = this.toEpoch() - tOther.toEpoch();
		end

		% return a clone of this as a new DateTime object
		function newDTime = clone(this)
			newDTime = DateTime( this.toString() );	
		end

	end % methods

	methods (Static)

		% month -> days (since jan 1st of this year)
		% TODO +1 day in leapyears
		% @param { int } month - integer representation of the given month
		function days = m2d(month,day)
			numdays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
			days = sum( numdays(1:month-1) ) + day;
		end

		% returns whether or not the given year is a leapyear
		% @return { boolean } - 
		function isLeapYear(year)
		end

		% 
		function leapDays(year)
		end

	end % static methods

end % DateTime