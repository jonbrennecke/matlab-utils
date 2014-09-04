function [ header, records ] = edftest ( filepath )
 
	% Parse EDF file information based on the EDF/EDF+ specs
	% @see http://www.edfplus.info/specs/index.html
 
	fid = fopen( filepath, 'rb' );
	data = fread(fid,256,'*char');
 
	% TODO regex to strip trailing whitespace
 
	header = struct();
	header.version = data(1:8);
	header.patient_id = data(9:88);
	header.rec_id = data(89:168);
	header.startdate = data(169:176);
	header.starttime = data(177:184);
	header.header_bytes = data(185:192);
	header.num_items = data(237:244);
	header.data_duration = data(245:252);
	header.num_signals = str2double(data(253:256));
 
	% advance to the second part of the header
 
	lengths = [ 16, 80, 8, 8, 8, 8, 8, 80, 8, 32 ];
	values = cell(length(lengths),header.num_signals);
 
 	headerkeys = { 
		'labels', 
		'transducer',
		'dimension',
		'phys_min',
		'phys_max',
		'dig_min',
		'dig_max',
		'prefiltering',
		'num_samples',
		'reserved' 
	};

	for i=1:length(lengths)
		for j=1:header.num_signals
			values{i,j} = fread(fid,lengths(i),'*char')';
		end
		header.(headerkeys{i}) = cell2mat(values(i,:)');
	end

	% TODO there may a better way to do this
	header.phys_max = str2num(header.phys_max);
	header.phys_min = str2num(header.phys_min);
	header.dig_max = str2num(header.dig_max);
	header.dig_min = str2num(header.dig_min);
	header.num_samples = str2num(header.num_samples);
 
	% the data record begins at 256 + ( num_signals * 256 ) bytes and is stored as n records of 2 * num_samples bytes
	% values are stored as 2 byte ascii in 2's complement
	records = cell(header.num_signals,1);

	scalefac = (header.phys_max - header.phys_min)./(header.dig_max - header.dig_min);
    dc = header.phys_max - scalefac .* header.dig_max;
 
	for i=1:header.num_signals
		data = fread(fid, header.num_samples(i),'int16') * scalefac(i) + dc(i);
		records{i} = data;
	end
 
 
	% finally, close the file and return
	fclose(fid);
end