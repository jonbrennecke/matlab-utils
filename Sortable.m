% 
% abstract base class for events sorted by time stamp
% 
classdef Sortable < Core

	properties (Hidden,SetAccess = protected)
		sort_key__ = 1;
	end

	properties (Abstract,Hidden,SetAccess = protected)
		fs;
		starttime;
	end

	properties (SetAccess = public)
		
		% enum
		SECOND = 1;
		MINUTE = 60;
		HOUR = 60*60;
		DAY = 60*60*24;
		WEEK = 60*60*24*7;

	end

	methods

		% class constuctor
		function this=Sortable()
		end

	end

	methods(Hidden,Access = protected)

		function this = sort_by_frequency__(this,enum,n,data)
			this.sort_key__ = n*enum; 
		end


	end

	methods(Abstract)
		sort(this,enum,n) % implements either __sort_by_timestamp or __sort_by_frequency
		times(this) % returns the timestamps as unix times
	end
end