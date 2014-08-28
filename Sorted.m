% 
% abstract base class for events sorted by time stamp
% 
classdef Sorted < handle

	properties (Hidden,SetAccess = protected)
	end

	properties (Abstract,Hidden,SetAccess = protected)
		fs;
		starttime;
	end

	properties (SetAccess = public)
		
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

		% class constuctor
		function this=Sorted()
		end

		% class destructor
		function delete(this)
		end

	end

	methods(Hidden,Access = protected)

		function sorted = sort_by_frequency__(this,enum,n,data)

			switch enum
				case txt.MINUTE
					n = 60*n;
				case txt.HOUR
					n = 60*60*n;
				case txt.DAY
					n = 60*60*24*n;
				case txt.WEEK
					n = 60*60*24*7*n;
			end

			k = 1; l = 1;
			times = this.times;

			for i=1:size(times,1)
				
				sorted = zeros(this.fs(i)*n,ceil(length(times(i,:))/this.fs(i)*n));

				for j=1:length(times(i,:))
					if mod(times(i,j), n) == 0
						k = k+1;
                        l = 1;
					end
					sorted(k,l) = data(i,j);
                    l = l+1;
				end
			end

		end


	end

	methods(Abstract)
		sort(this,enum,n) % implements either __sort_by_timestamp or __sort_by_frequency
		times(this) % returns the timestamps as unix times
	end
end