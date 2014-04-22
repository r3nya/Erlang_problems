-module('db_dets').
-compile(export_all).
-include("db_record.hrl").

start() ->
  {ok, Table} = dets:open_file(database, [{keypos, #person.name}]),
  register(db, spawn(?MODULE, db_loop, [Table])).

stop()  ->
  db ! stop.
  
db_loop(Table) ->
  receive
    {help} ->
      io:format("You may search/insert/delete data.~n"),
      db_loop(Table);

    {insert, Name, Location, Company}  ->
      dets:insert(Table, #person{name = Name, location = Location, company = Company}),
      db_loop(Table);
    
    {search_by_name, Data}  ->
      io:format("~w~n", [dets:lookup(Table, Data)]),
      db_loop(Table);
      
    {search_by_location, Data}  ->
      io:format("~p~n", [dets:match(Table, #person{name = '$1', location = Data, company = '_'})]),
      db_loop(Table);
    
    {search_by_company, Data} ->
      io:format("~w~n", [dets:match(Table, #person{name = '$1', location = '_', company = Data})]),
      db_loop(Table);

    {remove, Name}  ->
      db_loop(dets:delete(Table, Name));
    
    {all_names} ->
      io:format("~w~n", [dets:match(Table, #person{name = '$1', location = '_', company = '_'})]),
      db_loop(Table);
    
    {all_locations} ->
      io:format("~w~n", [lists:sort(dets:match(Table, #person{name = '_', location = '$1', company = '_'}))]),
      db_loop(Table);
    
    stop ->
      dets:delete_all_objects(Table),
      dets:close(Table),
      exit("Bye!")
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

all_names() ->
  db ! {all_names}.

all_locations() ->
  db ! {all_locations}.