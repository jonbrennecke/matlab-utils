% 
% file handler base class
% 
classdef FileHandle < handle

	properties (Hidden,SetAccess = protected)
		fd;
		filepath;
	end

	methods

		% class constuctor
		function this=FileHandle(filepath,filemode)
			this.fd = fopen(filepath,filemode);
			this.filepath = filepath;
		end

		% class destructor
		function delete(this)
			fclose(this.fd);
		end

	end
end