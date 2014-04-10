-module('min_max').
-export([list_min/1, list_max/1, list_min_max/1]).

%% Returns the minimum element of the list 

list_min([ Head | Tail_of_list ]) -> list_min(Tail_of_list, Head).

list_min([], Result) ->
	Result;
list_min([Head | Tail], Result_tmp) when Head < Result_tmp ->
	list_min(Tail, Head);
list_min([Head | Tail], Result_tmp) ->
	list_min(Tail, Result_tmp).

%% Returns the maximum element of the list 
  
list_max([ Head | Tail]) -> list_max(Tail, Head).

list_max([], Result) ->
  Result;
list_max([Head | Tail], Result_tmp) when Head > Result_tmp ->
  list_max(Tail, Head);
list_max([Head | Tail], Result_tmp) ->
  list_max(Tail, Result_tmp).
  
%% Min & Max

list_min_max(L) ->
  io:format("{~w, ~w}~n", [list_min(L), list_max(L)]).
