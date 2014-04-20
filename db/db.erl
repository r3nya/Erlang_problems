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
      Storage1 = lists:append(Storage, Data),
      db_loop(Storage1);
    
    {search_by_name, Data}  ->
      % bla-bla
      db_loop(Storage);
    {search_by_location, Data}  ->
      db_loop(Storage);

    {remove, Name}  ->
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