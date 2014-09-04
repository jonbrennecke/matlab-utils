% 
% 
% --------------- TODO
% 
% text file handler class
% 
classdef txt

	properties (Hidden,SetAccess = private)
		fd;
		data;
		fmt = 'mm/dd/yyyy,HH:MM:SS';
	end

	properties (Constant)

		% enum
		SECOND = 1;
		MINUTE = 2;
		HOUR = 3;
		DAY = 4;
		WEEK = 5;
		MONTH = 6;
		YEAR = 7;

	end

	methods

		% class constructor
		function this=txt( txtfile )
			this.fd = fopen(txtfile,'r');

			% read lines
			scan = textscan(this.fd,'%s','Delimiter','\n');
			lines = scan{1};

			% use the length of the first line to vivify a cell matrix
			line = textscan(lines{1},'%s','Delimiter','\t');
			this.data = cell(length(lines),length(line{1}));
			this.data(1,:) = line{1};
			n = size(this.data,2);

			% read all the other lines into the data matrix
			for i=2:length(lines)
			    line = textscan(lines{i},'%s');
			    this.data(i,:) = line{1}(1:n);
			end
		end

		% class destructor
		function delete( this )
			fclose(fd);
		end

		% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		% getter and setter methods
		% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		% sleep scores getter/setter method
		% assumes that sleep scores are the 3rd column
		function [scores] = scores( this, val )
			if exist('val','var') % setter
				this.data(3:end,3) = val;
			end
			scores = this.data(3:end,3);
		end

		% timestamp getter/setter method
		% assumes that timestamps are the 1st column
		function [times] = times( this, val )
			if exist('val','var') % setter
				this.data(3:end,1) = val;
			end
			times = this.data(3:end,1);
		end

		% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		% methods
		% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		% report rows as cell arrays of rows, where the contents of each cell array are the contents of
		% each subsequent n seconds, minutes, days, etc.
		% 
		% :param enum - one of the enumerated types from HOUR, MIN, etc.
		% :param n - the number of intervals to sort by
		function [sorted] = sort( this, enum, n )

			multiplier = 1;
			switch enum
				case txt.SECOND
					% pass
				case txt.MINUTE
					multiplier = 60;
				case txt.HOUR
					multiplier = 60*60;
				case txt.DAY
					multiplier = 60*60*24;
				case txt.WEEK
					multiplier = 60*60*24*7;
				otherwise
					% pass
			end

			times = this.times;
			sorted = [];

			for i=1:length(times)
				% time = datetime( datetime.struct_from_datevec(datevec(times{i},this.fmt)) );
				if mod(time,multiplier*n) == 0
					% new cell
				end
			end

		end


	end
end