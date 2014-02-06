% takes str and puts a backslash in front of every character that is part of the
% regular expression syntax. This is useful if you have a run-time string that 
% you need to match in some text and the string may contain special regex 
% characters.
%
% @see PHP's 'preg_quote' / http://php.net/manual/en/function.preg-quote.php
%
function str = reg_escape_string(str)
	
end