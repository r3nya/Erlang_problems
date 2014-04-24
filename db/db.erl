-module('db').
-compile(export_all).

start() ->
  register(db, spawn(?MODULE, db_loop, [[{andrey, nn}]])).

stop()  ->
  db ! stop.
  
db_loop(Storage) ->
  receive
    {help} ->
      io:format("You may search/insert/delete data.~n"),
      db_loop(Storage);
    
    {view}  ->
      io:format("View DB~n"),
      lists:map(fun(X) -> io:format("~w~n", [X]) end, Storage),
      db_loop(Storage);

    {insert, Data}  ->
      db_loop([Data|Storage]);
    
    {search_by_name, Data}  ->
      io:format("~p~n", [lists:keysearch(Data, 1, Storage)]),
      db_loop(Storage);
      
    {search_by_location, Data}  ->
      io:format("~p~n", [lists:keysearch(Data, 2, Storage)]),
      db_loop(Storage);

    {remove, Name}  ->
      db_loop(lists:keydelete(Name, 1, Storage));
    
    {all_names} ->
      io:format("~p~n",[lists:map(fun({X, _}) -> X end, Storage)]),
      db_loop(Storage);
    
    {all_locations} ->
      io:format("~p~n",[lists:map(fun({_, X}) -> X end, Storage)]),
      db_loop(Storage);
    
    stop -> server_terminated, exit("Bye!")
  end.
      
% User cli

help()  ->
  db ! {help}.
      
insert(Data) ->
  db ! {insert, Data}.

where_is(Name) ->
  db ! {search_by_name, Name}.

located_at(Location)  ->
  db ! {search_by_location, Location}.

remove(Name)  ->
  db ! {remove, Name}.

view()  ->
  db ! {view}.

all_names() ->
  db ! {all_names}.

all_locations() ->
  db ! {all_locations}.