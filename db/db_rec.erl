-module('db_rec').
-compile(export_all).
-include("db_record.hrl").

start() ->
  register(db, spawn(?MODULE, db_loop, [[]])).

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

    {insert, Name, Location, Company}  ->
      db_loop([#person{name = Name, location = Location, company = Company}|Storage]);
    
    {search_by_name, Data}  ->
      io:format("~p~n", [lists:keysearch(Data, #person.name, Storage)]),
      db_loop(Storage);
      
    {search_by_location, Data}  ->
      io:format("~p~n", [lists:keysearch(Data, #person.location, Storage)]),
      db_loop(Storage);
    
    {search_by_company, Data} ->
      io:format("~p~n", [lists:keysearch(Data, #person.company, Storage)]),
      db_loop(Storage);

    {remove, Name}  ->
      db_loop(lists:keydelete(Name, #person.name, Storage));
    
    {all_names} ->
      io:format("~p~n",[lists:map(fun(#person{name=X})  -> X end, Storage)]),
      db_loop(Storage);
    
    {all_locations} ->
      lists:map(fun(#person{location=X}) -> io:format("~p~n", [X]) end, Storage),
      db_loop(Storage);
    
    stop -> server_terminated, exit("Bye!")
  end.
      
% User cli

help()  ->
  db ! {help}.
      
insert(Name, Location, Company) ->
  db ! {insert, Name, Location, Company}.

where_is(Name) ->
  db ! {search_by_name, Name}.

located_at(Location)  ->
  db ! {search_by_location, Location}.
  
working_at(Name)  ->
  db ! {search_by_company, Name}.

remove(Name)  ->
  db ! {remove, Name}.

view()  ->
  db ! {view}.

all_names() ->
  db ! {all_names}.

all_locations() ->
  db ! {all_locations}.