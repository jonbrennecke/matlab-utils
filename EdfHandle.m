% 
% text file handler class
% 
classdef EdfHandle < FileHandle & Sortable

	properties (SetAccess = protected)

		% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		% this properties
		% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~

		% fixed length this constants
		version;
		patient_id;
		record_id;
		starttime;
		bytes;
		nr;
		duration;
		ns;

		% variable length this constants
		labels;
		transducer;
		units;
		phys_min;
		phys_max;
		dig_min;
		dig_max;
		prefiltering;
		samples;
		reserved;
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
			for i=1:length(this.labels)
				this.signals{i} = ArrayTimeView(this,this.data{i},times{i},this.fs(i));
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

			% otherwise, match with the signal labels names (eg, 'eeg1','emg') and 
			% pass throught to the ArrayTimeView objects
			else
				i = find(cellfun(@(x)strcmpi(x,s(1).subs),this.labels));
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
			times = cell(size(this.data));
			for i=1:this.ns
				tick = 1/this.fs(i); % each sample increments the time by this much
				times{i} = this.starttime.unix + (1:length(this.data{i}))*tick;
			end
		end

	end
	methods(Access=private)

		function read__(this)
 
			% Parse EDF file information based on the EDF/EDF+ specs
			% @see http://www.edfplus.info/specs/index.html
		 
			data = fread(this.fd,256,'*char');
		 
			this.version = data(1:8);
			this.patient_id = data(9:88);
			this.record_id = data(89:168);

			% combine the start date and start time into a DateTime object
			startdate = strtrim(data(169:176));
			starttime = strtrim(data(177:184));
			this.starttime = DateTime( DateTime.struct_from_datevec(datevec([ startdate' ', ' starttime'],'dd.mm.yy, HH.MM.SS')) );
			
			this.bytes = data(185:192);
			this.nr = data(237:244);
			this.duration = str2double(data(245:252));
			this.ns = str2double(data(253:256));
		 
			% advance to the second part of the header,
			% containing information about each signal
		 
			lengths = [ 16, 80, 8, 8, 8, 8, 8, 80, 8, 32 ];
			values = cell(length(lengths),this.ns);
		 
		 	headerkeys = { 
				'labels', 
				'transducer',
				'units',
				'phys_min',
				'phys_max',
				'dig_min',
				'dig_max',
				'prefiltering',
				'samples',
				'reserved' 
			};

			for i=1:length(lengths)
				for j=1:this.ns
					values{i,j} = fread(this.fd,lengths(i),'*char')';
				end
				this.(headerkeys{i}) = values(i,:);
			end

			% TODO there may a better way to do this
			this.phys_max = str2num(cell2mat(this.phys_max'));
			this.phys_min = str2num(cell2mat(this.phys_min'));
			this.dig_max = str2num(cell2mat(this.dig_max'));
			this.dig_min = str2num(cell2mat(this.dig_min'));
			this.samples = str2num(cell2mat(this.samples'));
			this.labels = strtrim(this.labels);
			this.units = strtrim(this.units);
		 
			% the data record begins at 256 + ( ns * 256 ) bytes and is stored as n records of 2 * samples bytes
			% values are stored as 2 byte ascii in 2's complement
			this.data = cell(this.ns,1);

			scalefac = (this.phys_max - this.phys_min)./(this.dig_max - this.dig_min);
		    dc = this.phys_max - scalefac .* this.dig_max;
		 
			for i=1:this.ns
				this.data{i} = fread(this.fd, this.samples(i),'int16') * scalefac(i) + dc(i);
			end

		    % implementing fs (frequency) is necessary to subclass Sorted
		    this.fs = this.samples/this.duration;

		end %end read__
	end % end methods
end % end EdfHandle