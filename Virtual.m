% 
% Virtual allows the creation of virtual functions
% 
% Virtual is one of the few classes in the utils package that doesn't inherit from Core
% This is because Virtual is used by Core to create Virtual functions 
% 
classdef Virtual < handle

	properties
		name;
	end

	properties(Hidden,Access=private)
		get_callback;
		set_callback;
	end

	methods

		% class constuctor
		function this=Virtual(name)
			this.name = name;
		end

	end

	methods

		% define the get callback
		function this = get(this,callback)
			this.get_callback = callback;
		end

		% define the set callback
		function this = set(this,callback)
			this.set_callback = callback;
		end

		function varargout = callback(this,varargin)
			if ~isempty(varargin) % set
				[varargout{1:nargout}] = this.set_callback(varargin{:});
			else % get
				[varargout{1:nargout}] = this.get_callback();
			end
		end


	end
end