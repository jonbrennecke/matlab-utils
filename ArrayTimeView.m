classdef ArrayTimeView < Core

	properties (SetAccess = protected)
		parent;
		data;
		times;
		fs;
	end

	methods

		function this=ArrayTimeView(parent,data,times,fs)
			this.parent = parent;
			this.data = data;
			this.times = times;
			this.fs = fs;
		end

		function varargout = subsref(this,s)
			if strcmp(s(1).type,'()') % called

				idx = s(1).subs{:};
				len = this.fs*this.parent.sort_key__; % number of samples in an interval

				% find the first interval break and save it as the onset
				onset = find(mod(this.times(1:len),this.parent.sort_key__)==0);

				% loop through the indices and select the given time interval
				strt = onset+(idx)*len;
                
                starttimes = this.times(strt);
                for i=1:length(starttimes)
                    datetimes{i} = DateTime(starttimes(i));
                end

				[x1,x2]=ndgrid(strt,1:len);
				varargout = { this.data(x1+x2), datetimes };
			
			% passthrough to methods and properties
			elseif ismethod(this,s(1).subs) || isprop(this,s(1).subs)
				if length(s)>1
					varargout = {this.(s(1).subs)(s(2).subs{:})};
				else
					varargout = {this.(s(1).subs)};
				end
			end
		end

	end
end