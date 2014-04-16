-module('perimeter').
-export([perimeter/1]).
 
perimeter({square, X}) ->
	X * 2;
perimeter({circle, R}) ->
	math:pi() * math:pow(R, 2);
perimeter({triangle, A, B, C}) ->
	A + B + C;
perimeter(_) ->
	io:format("Error!~n").
