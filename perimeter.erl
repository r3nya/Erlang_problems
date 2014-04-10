-module('perimeter').
-export([perimeter/1]).
 
perimeter({square, X}) ->
	X * 2;
perimeter({circle, R}) ->
	2 * math:pi() * R;
perimeter({triangle, A, B, C}) ->
	A + B + C;
perimeter(_) ->
	io:format("Error!~n").
