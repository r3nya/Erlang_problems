-module(ring).
-export([start/2, loop/2]).

start(N, M) ->
  Seq = lists:seq(1, N),     %% [1,2...9,10]
  Messages = lists:reverse(lists:seq(0, M-1)),
  LastP = lists:foldl(fun(S, Pid) -> spawn(?MODULE, loop, [N-S, Pid]) end, self(), Seq),
  spawn(fun() -> [ LastP ! R || R <- Messages ] end).
  
loop(N, NextPid) ->
    receive
      R when R > 0 ->
        NextPid ! R,
        io:format(": Process: ~8w, Sequence#: ~w, Message#: ~w ..~n", [self(), N, R]), loop(N, NextPid);
      R when R =:= 0 ->
        NextPid ! R,
        io:format("* Process: ~8w, Sequence#: ~w, Message#: terminate!~n", [self(), N])
    end.