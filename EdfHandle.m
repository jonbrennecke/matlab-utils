% 
% text file handler class
% 
classdef EdfHandle < FileHandle & Sortable

	properties (SetAccess = protected)

		% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		% header properties
		% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		% fixed length header constants
		ver;
		patientID;
		recordID;
		starttime;
		bytes;
		nr;
		duration;
		ns;

		% variable length header constants
		label;
		transducer;
		units;
		physicalMin;
		physicalMax;
		digitalMin;
		digitalMax;
		prefilter;
		samples;
		fs;

		% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		% data matrix
		data;
		signals = {};

	end

	methods

		% class constructor
		function this=EdfHandle( edffile )
			
			% call the FileHandle class constructor with arguments
			this = this@FileHandle(edffile,'rb');

			% read the edf file 
			this.read__();

			% create a vector of unix timestamps
			times = this.times();

			% create ArrayTimeView objects for each label
			for i=1:length(this.label)
				this.signals{i} = ArrayTimeView(this,this.data(i,:),times(i,:));
			end

		end

		% overload the subsref operator to allow calling
		function varargout = subsref(this,s)
			if s(1).type ~= '.' 
				error('EdfHandle is not callable.');
			end

			% passthrough to methods and properties
			if ismethod(this,s(1).subs) || isprop(this,s(1).subs)
				if length(s)>1
					varargout = {this.(s(1).subs)(s(2).subs{:})};
				else
					varargout = {this.(s(1).subs)};
				end

			% otherwise, match with the signal label names (eg, 'eeg1','emg') and 
			% pass throught to the ArrayTimeView objects
			else
				i = find(cellfun(@(x)strcmpi(x,s(1).subs),this.label));
				if length(s)>1 && iscell(s(2).subs)
					varargout = { subsref(this.signals{i},struct('type','()','subs',s(2).subs{:})) };
                elseif length(s)>1 && ischar(s(2).subs) % get properties
                    varargout = {this.signals{i}.(s(2).subs)};
				else
					varargout = {this.signals{i}};
				end
			end
		end

		% EDFs are sorted by frequency
		function sorted = sort(this,enum,n)
			sorted = this.sort_by_frequency__(enum,n,this.data);
		end

		% implementation of the abstract function in the parent class Sorted
		% returns a vector of unix timestamps equal in size to the data vector
		function times = times(this)
			times = zeros(size(this.data));
			for i=1:this.ns
				tick = 1/this.fs; % each sample increments the time by this much
				times(i,:) = this.starttime.unix + (1:length(times(i,:)))*tick;
			end
		end

	end
	methods(Access=private)

		function read__(this)

			% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			% borrowed from some code by Brett Shoelson, PhD
			% brett.shoelson@mathworks.com
			% Copyright 2009 - 2012 MathWorks, Inc.
			% 8/27/09
			% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

			% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			% HEADER
			% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

			this.ver = str2double(char(fread(this.fd,8)'));
			this.patientID = fread(this.fd,80,'*char')';
			this.recordID = fread(this.fd,80,'*char')';
			startdate = fread(this.fd,8,'*char')'; % (dd.mm.yy)
			starttime = fread(this.fd,8,'*char')'; % (hh.mm.ss)
			this.bytes = str2double(fread(this.fd,8,'*char')');
			reserved = fread(this.fd,44);
			this.nr = str2double(fread(this.fd,8,'*char')');
			this.duration = str2double(fread(this.fd,8,'*char')');
			this.ns = str2double(fread(this.fd,4,'*char')');
			this.starttime = DateTime( DateTime.struct_from_datevec(datevec([ startdate ', ' starttime],'dd.mm.yy, HH.MM.SS')) );

			for ii = 1:this.ns
			    this.label{ii} = regexprep(fread(this.fd,16,'*char')','\W','');
			end

		    targetSignals = 1:numel(this.label);
			if iscell(targetSignals)||ischar(targetSignals)
			    targetSignals = find(ismember(this.label,regexprep(targetSignals,'\W','')));
			end
			if isempty(targetSignals)
			    error('EDFREAD: The signal(s) you requested were not detected.')
			end

			for ii = 1:this.ns
			    this.transducer{ii} = fread(this.fd,80,'*char')';
			end
			% Physical dimension
			for ii = 1:this.ns
			    this.units{ii} = fread(this.fd,8,'*char')';
			end
			% Physical minimum
			for ii = 1:this.ns
			    this.physicalMin(ii) = str2double(fread(this.fd,8,'*char')');
			end
			% Physical maximum
			for ii = 1:this.ns
			    this.physicalMax(ii) = str2double(fread(this.fd,8,'*char')');
			end
			% Digital minimum
			for ii = 1:this.ns
			    this.digitalMin(ii) = str2double(fread(this.fd,8,'*char')');
			end
			% Digital maximum
			for ii = 1:this.ns
			    this.digitalMax(ii) = str2double(fread(this.fd,8,'*char')');
			end
			for ii = 1:this.ns
			    this.prefilter{ii} = fread(this.fd,80,'*char')';
			end
			for ii = 1:this.ns
			    this.samples(ii) = str2double(fread(this.fd,8,'*char')');
			end
			for ii = 1:this.ns
			    reserved    = fread(this.fd,32,'*char')';
			end
			this.label = this.label(targetSignals);
			this.label = regexprep(this.label,'\W','');
			this.units = regexprep(this.units,'\W','');

		    % Scale data (linear scaling)
		    scalefac = (this.physicalMax - this.physicalMin)./(this.digitalMax - this.digitalMin);
		    dc = this.physicalMax - scalefac .* this.digitalMax;
		    
		    tmpdata = struct;
		    for recnum = 1:this.nr
		        for ii = 1:this.ns
		            % Read or skip the appropriate number of data points
		            if ismember(ii,targetSignals)
		                % Use a cell array for DATA because number of samples may vary
		                % from sample to sample
		                tmpdata(recnum).data{ii} = fread(this.fd,this.samples(ii),'int16') * scalefac(ii) + dc(ii);
		            else
		                fseek(this.fd,this.samples(ii)*2,0);
		            end
		        end
		    end
		    this.units = this.units(targetSignals);
		    this.physicalMin = this.physicalMin(targetSignals);
		    this.physicalMax = this.physicalMax(targetSignals);
		    this.digitalMin = this.digitalMin(targetSignals);
		    this.digitalMax = this.digitalMax(targetSignals);
		    this.prefilter = this.prefilter(targetSignals);
		    this.transducer = this.transducer(targetSignals);

			% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
			% data
			% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		    
		    this.data = zeros(numel(this.label), this.samples(1)*this.nr);
		    
		    recnum = 1;
		    for ii = 1:this.ns
		        if ismember(ii,targetSignals)
		            ctr = 1;
		            for jj = 1:this.nr
		                try
		                    this.data(recnum, ctr : ctr + this.samples(ii) - 1) = tmpdata(jj).data{ii};
		                end
		                ctr = ctr + this.samples(ii);
		            end
		            recnum = recnum + 1;
		        end
		    end
		    this.ns = numel(this.label);
		    this.samples = this.samples(targetSignals);

			% Since different signals may have been read at different frequencies, I need 
			% to interpolate those that are sampled at a lower frequency than the highest frequency

			% Find the largest values in this.samples (this is the number of samples per 'duration' seconds)
			max_samples_per_epoch = max(this.samples(1:4));   %I'm leaving off EDFAnnotations because I don't care about interpolating them
			scale_factor = ones(1,4);

			    for i=1:4
			        if this.samples(i) ~= max_samples_per_epoch
			            scale_factor(i) = max_samples_per_epoch/this.samples(i);
			        end 
			    end 

			    num_of_vars_to_scale = sum(scale_factor~=1);
			    indices = find(scale_factor~=1);

			    % Now loop over all the variables that need scaling
			    for i=1:num_of_vars_to_scale 
			        a = find(this.data(indices(i),:)==0);
			        first_zero_loc = a(1);
			        X = 0:1:first_zero_loc-2;
			        V = this.data(1,1:first_zero_loc-1);
			        Xq = 0:1/scale_factor(indices(i)):first_zero_loc-1;
			        Xq=Xq(1:end-1);
			        newlactatevec = interp1(X,V,Xq);
			        this.data(indices(i),:) = newlactatevec;
			    clear a X Xq V 
		    end

		    % implementing fs (frequency) is necessary to subclass Sorted
		    this.fs = size(this.data,2)/this.duration;

		end %end read__
	end % end methods
end % end EdfHandle