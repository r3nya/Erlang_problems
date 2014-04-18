-module('new_ring').
-export([start/2, tim3s/2, listen/0, loop/2, terminate/1]).
 
start(N, M)   ->
  List = loop(N, []),
  send(M, List),
  terminate(List).
 
loop(0, List)   ->
  lists:append(List, [hd(List)]);
loop(N, List)   ->
  loop(N-1, [spawn(?MODULE, listen, []) | List]).
 
listen()        ->
  receive
    {Msg}   ->
      io:format("Process ~w received message ~w.~n", [self(), Msg]),
      listen();
    stop    ->
      true
  end.
 
send(0, List)   ->
  {ok};
send(M, List)   ->
  tim3s(erlang:length(List), List),
  send(M-1, List).
 
tim3s(0, []) ->
  {ok};
tim3s(_ ,List1) ->
  [Head1 | Tail1] = List1,
  Head1 ! {hello},
  tim3s(erlang:length(Tail1), Tail1).
 
terminate([])   ->
  {ok};
terminate(L)    ->
  [H | T] = L,
  H ! stop,
  io:format("Process ~w stoped!~n", [H]),
  terminate(T).