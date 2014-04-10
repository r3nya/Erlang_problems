-module('swedish_date').
-export([say/0]).

say() ->
  {Y, M, D} = date(),
  io:format("~w ~w ~w~n", [Y, M, D]).