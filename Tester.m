classdef Tester < Core

	properties
		

	end

	methods

		% class constructor
		function this = Tester()
			this.virtual('test').get(@()('got')).set(@(x)('set'));
		end

	end
end