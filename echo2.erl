-module('echo2').
-export([go/0, pong/0, ping/0]).
 
go() ->
  Pong = spawn(?MODULE, pong, []),
  Ping = spawn(?MODULE, ping, []),
 
  lists:map(fun(Time) -> Pong ! {Ping, Time} end, lists:seq(1,10)),
 
  Pong ! stop.
 
pong() ->
  receive
    {From, Msg} ->
      From ! {self(), Msg},
        io:format("**  Pong process ~w, message: ~w~n", [self(), Msg]),
        pong();
      stop ->
        true
      end.
 
ping() ->
  receive
    {Pid, Msg} ->
      io:format("*   Ping process ~w, message: ~w~n", [self(), Msg]),
      ping()
  end.