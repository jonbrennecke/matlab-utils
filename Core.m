% 
% everything in the utils package inherits from Core
% 
% Core is an abstract base class, meaning that it serves as a prototype for classes, but it
% shouldn't be instantiated directly.
% 
classdef(Abstract) Core < handle

	properties (Access = protected)
		TIMESTAMP = 1;
	end

	properties (Access = private)

		% virtual function lookup table
		virtual_functions__ = Virtual.empty(0,0)
	end

	methods

		% class constructor
		% since Core is an abstract base class, the class cannot be instantiated; so the 
		% constructor should remain empty
		function this=Core()
		end

		% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		% matlab classes don't support virtual methods by default, so in order to support them,
		% we can overload subsref and subsasgn with custom functions
		% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		function method = virtual(this,method_name)

			% append the method name to the virtual function lookup table and return the 
			% virtual function object
			this.virtual_functions__(end+1) = Virtual(method_name);
			method = this.virtual_functions__(end);

		end

		% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		% overloaded 'het' method
		% --
		% subsref is overloaded with the ability to call virtual functions
		% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		function varargout = subsref(this,s)
			
			i = find(strcmpi(this.virtual_functions__.name,s(1).subs));
			if s(1).type == '.' && i

				% otherwise, match with the name of a virtual function and 
				% pass through to it's callback function
				if length(s)>1 && iscell(s(2).subs)
					[varargout{1:nargout}] = builtin('subsref',this.virtual_functions__(i).callback,s(2:end));
				end

			else % passthrough
				[varargout{1:nargout}] = builtin('subsref',this,s);
			end

		end % end subsref

		% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		% overloaded 'set' method
		% --
		% subsasgn is overloaded with the ability to call virtual functions
		% ~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~~
		% function varargout = subsasgn(this,s,b)
			
		% 	i = find(strcmpi(this.virtual_functions__.name,s(1).subs));
		% 	if s(1).type == '.' && i

		% 		% otherwise, match with the name of a virtual function and 
		% 		% pass through to it's callback function
  %               [varargout{1:nargout}] = this.virtual_functions__(i).set(b);

		% 	else % passthrough
		% 		[varargout{1:nargout}] = builtin('subsref',this,s,b);
		% 	end

		% end % end subsasgn

	end % end methods
end % end classdef Core