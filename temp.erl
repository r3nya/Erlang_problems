-module(temp).
-export([convert/2]).
 
f2c(F) -> (F - 32) * 5 / 9.
 
c2f(C) -> C * 9 / 5 + 32.
 
convert(c, Temp) ->
	f2c(Temp);
convert({c, Temp}) ->
	f2c(Temp);
convert(f, Temp) ->
	c2f(Temp);
convert({f, Temp}) ->
	c2f(Temp);
convert(_, Temp) ->
	io:format("Stop feeding me wrong data!~n").
