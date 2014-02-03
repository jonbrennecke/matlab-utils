%
% An object-oriented handler for various OS and file I/O related functions
%
% by @jonbrennecke / https://github.com/jonbrennecke
%
% Released under the MIT license (see the accompanying LICENSE.txt)
%  
classdef OS

	properties (Hidden)
	end

	properties (SetAccess = private)
	end
	
	events   
	end

	methods

		function this = OS
			% this class is mostly just a container for various functions
			% with no properties to initialize
		end


	end % methods

	methods (Static)

		function text = open_file(filename)
		    fid = fopen(filename);
		    content = fread(fid,'*char');
		    text = split(content,'\n');
		end

	end % static methods

end % XL