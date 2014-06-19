%
% A namespace of various utility functions
%
% by @jonbrennecke / https://github.com/jonbrennecke
%
% Released under the MIT license (see the accompanying LICENSE.txt)
%  
classdef Utils

	properties (Hidden)
	end

	properties (SetAccess = private)
	end
	
	events   
	end

	methods

		function this = Utils
			% this class is mostly just a container for various functions
			% with no properties to initialize
		end

	end % methods

	methods (Static)

		% reverse an array
		% TODO reverse array in place
		function iter = reverse(array)
		    for i=abs(-length(array):-1)
		        iter(length(array)-i+1)=array(i);
		    end
		end

		% create an iterable sequence going backwards, faster than 'reverse'
		function iter = bkwd(start,stop)
		    iter = abs(-start:-stop);
		end

		% strip all instances of param 'substr' from str
		function ret = strip(str,substr)
		    chunks = Utils.split(str,substr);
		    ret = '';
		    for i=1:length(chunks)
		        ret = [ ret char(chunks(i)) ];
		    end
		end

		% position(s) of 'delimiter' in array
		function ret = index(array,delimiter)
		    ret = find( array == delimiter);
		end

		% split string or array at delimiter
		% all this does is call the appropriate functions (strsplit or arraysplit)
		function matches = split(in,delimiter)
		    if isstr(in) matches = Utils.strsplit(in,delimiter);
		    else matches = Utils.arraysplit(in,delimiter); end
		end

		% split string at delimiter
		function matches = strsplit(str,delimiter)
		    % matches = textscan(str,'%s','delimiter',{delimiter,'*'});
		    matches = textscan(str,'%s','delimiter',delimiter);
		    matches = matches{1,:};
		end

		% split array at delimiter
		function matches = arraysplit(array,delimiter)
		    indx = [ 0 index(array,delimiter) length(array) ];
		    for i=2:length(indx)
		        matches{i-1,:} = array(indx(i-1)+1:indx(i));
		    end
		end

		% return param 'array' as slices designated by param 'step'
		% alternative syntax: slice also accept array input for param 'step', to slice at multiple locations
		% designated by the elements of 'step'
		function ret = slice(array,step)
		    if numel(step)>1
		        ret{1,:} = array(1:step(1));
		        for i=1:length(step)-1
		            ret{i+1,:} = array(step(i):step(i+1)-1);
		        end
		        ret{length(step),:} = array(step(length(step)-1):end);
		    else
		        for i=0:floor(length(array)/step)-1
		            ret(i+1,:) = array((i*step)+1:(i+1)*step);
		        end
		    end
		end

		% downsample an array by param 'step'
		function ret = downsample(array,step)
		    ret = mean( Utils.slice(array,step), 2 );
		end

		% implementation of an array mapping function (i.e. compare to Python Standard Lib 'map')
		% apply param 'callback' to every element in param 'array' and return the result in an array
		function ret = map(callback,array)
		    ret = cell(0,numel(array));
		    for i=1:numel(array)
		        ret{i} = callback(array(i));
		    end
		end

		% return a sequence consisting of those items from the esequence for which 
		% param 'callback(array(i))' evalutes as true.
		function ret = filter(callback,array)
		    ret = [];
		    for i=1:numel(array)
		        if callback(array(i))
		            ret(end+1) = array(i);
		        end
		    end
		end

		% Implementation of a ternary operator
		% if condition evaluates to 'true' return the result of callback 'a', 
		% otherwise, return the result of callback 'a'
		function ret = ternary(cond,a,b)
		    if cond() 
		        try ret = a(); disp('here'), return
		        catch e
		        end
		    ret = b(); end
		end

		% implementation of an autovivification function (i.e. compare to autovivification in Perl)
		function vivify
		end

		% map every element of param 'array' to its keyed element in param 'hash'
		% return the resulting array 
		function hashmap( array, hash )
		end


		% Estimate the power spectra of a signal using Bartlett's Method, or, if parameter 'overlap' is specified, using Welch's Method.
		% This method is based on the concept of using periodogram spectrum estimates, which are the result of converting a signal from the 
		% time domain to the frequency domain. 
		% 
		% @see Bartlett, M.S. (1948). "Smoothing Periodograms from Time-Series with Continuous Spectra". Nature 161: 686–687.
		% @see Welch, P.D. (1967) "The Use of Fast Fourier Transform for the Estimation of Power Spectra: A Method Based on 
		% Time Averaging Over Short, Modified Periodograms", IEEE Transactions on Audio Electroacoustics, AU-15, 70–73.
		% 
		% @link http://en.wikipedia.org/wiki/Bartlett%27s_method
		% @link http://en.wikipedia.org/wiki/Welch_method
		% @link http://www.mathworks.com/help/matlab/examples/using-fft.html
		% 
		% @param signal - data signal
		% @param m - length of data segments
		% @param rate - sampling frequency (eg 400Hz)
		% @param overlap - 0% is Bartlett's method
		% 
		% @return pow - estimate of the power spectrum at a given frequency 
		% @return freq - corresponding frequency vect
		% 
		function [ pow, freq, test ] = periodogram( signal, m, rate, overlap )

			% if the 'overlap' parameter is defined, use the Welch Method and split into overlapping windows
			if exist( 'overlap' )
				starts = [ 0 : m - overlap: length( signal ) - m ];
				ends = starts + m;

				segments = [];
				for i = 1:length(starts)
					segments(end+1,:) = signal( starts(i)+1 : ends(i) );
				end

				k = size( segments, 1 ) - 1;
			
			% if the 'overlap' parameter isn't defined, default to Barlett's Method and use adjacent windows
			else 
				% slice signal into k data segments of length m
				segments = Utils.slice(signal, m);

				k = ( length( signal ) / m ) - 1;
			end

			% compute the FFT of each segment, then compute the squared magnitude of the 
			% result and divide by m
			period = ( fft(segments,[],2).^2 ) / m;

			test = segments;
			
			% average each of the k data segments
			pow = mean( period( 2:end, : ), 2 );

			% discretization frequency
			df = ( 1 / k * rate );

			freq = ( [1:k] / k ) .* df;

		end


	end % static methods

end % end Utils