classdef DateTime

	properties (SetAccess = private)
		
		% DateTime defaultd
		datetime_struct = struct( ...
			'months', 0, ...
			'days', 0, ...
			'years', 0, ...
			'hours', 0, ...
			'minutes', 0, ...
			'seconds', 0 ...
		);

		% unix time representation (the number of seconds since Jan 1st, 1970)
		unix_time;

	end

	methods

		% class constructor
		function this = DateTime( datetime_struct )

			if isstruct(datetime_struct)
				this.datetime_struct = this.concat(datetime_struct,this.datetime_struct);
				
				% number of days since unix epoch
				this.unix_time = ( this.datetime_struct.years - 1970 ) * 365;

				% plus number of days into current year, converted to seconds
				this.unix_time = ( this.unix_time + this.m2d(this.datetime_struct.months,this.datetime_struct.days) ) * 86400;

				% plus hour, min, sec offset from time-of-day
				this.unix_time = this.unix_time + ( ( this.datetime_struct.hours * 60 + this.datetime_struct.minutes ) * 60 + this.datetime_struct.seconds );
			end

			if isnumeric(datetime_struct)
				this.unix_time = datetime_struct;
			end

		end

		% time in unix time (number of seconds since Jan 1, 1970)
		function time = unix( this )
			time = this.unix_time;
		end

		% convert a time into a string
		function str = str( this, fmt )
			str = datestr(this.datenum(), fmt);
		end

		% matlab datenum representation
		function num = datenum( this )
			num = this.unix_time/86400 + datenum(1970,1,1);
		end


		% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		% operators
		% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~


		% less than
		function bool = lt(a,b)
			if ~strcmp(class(a),'DateTime')
				a = DateTime(a);
			end
			if ~strcmp(class(b),'DateTime')
				b = DateTime(b);
			end
			bool = a.unix < b.unix;
		end

		% greater than
		function bool = gt(this,other)
			if ~strcmp(class(a),'DateTime')
				a = DateTime(a);
			end
			if ~strcmp(class(b),'DateTime')
				b = DateTime(b);
			end
			bool = a.unix < b.unix;
		end 

	end
	methods (Static) % static class methods

		% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		% concatenate two structured arrays by copying field-value pairs from 'a' into 'b'
		% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		function b = concat(a,b)
			fieldsa = fieldnames(a);
			for i=1:length(fieldsa)
				b.(fieldsa{i}) = a.(fieldsa{i});
			end
		end

		% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		% convert months and day to the number of days since the beginning of the year
		% :param month - integer representation of the given month
		% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		function days = m2d(month,day)
			numdays = [31, 28, 31, 30, 31, 30, 31, 31, 30, 31, 30, 31];
			days = sum( numdays(1:month-1) ) + day;
		end

		% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		% create a datetime_struct from the result of matlab's datevec function
		% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		function datetime_struct = struct_from_datevec ( vec )
			tmp = num2cell(vec);
			[y,m,d,H,M,S] = tmp{:};
			datetime_struct = struct( ...
				'months', m, ...
				'days', d, ...
				'years', y, ...
				'hours', H, ...
				'minutes', M, ...
				'seconds', S ...
			);
		end

	end
end