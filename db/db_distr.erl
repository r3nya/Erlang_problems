-module('db_distr').
-compile(export_all).
-include("db_record.hrl").
-define(SERVER, 'localhost').

start() ->
  Table = ets:new(table, [public, {keypos, #person.name}]),
  register(db, spawn(?MODULE, db_loop, [Table])).

stop()  ->
  db ! stop.
  
db_loop(Table) ->
  receive
    {help} ->
      io:format("You may search/insert/delete data.~n"),
      db_loop(Table);

    {insert, Name, Location, Company}  ->
      ets:insert(Table, #person{name = Name, location = Location, company = Company}),
      db_loop(Table);
    
    {search_by_name, Data}  ->
      io:format("~w~n", [ets:lookup(Table, Data)]),
      db_loop(Table);
      
    {search_by_location, Data}  ->
      io:format("~p~n", [ets:match(Table, #person{name = '$1', location = Data, company = '_'})]),
      db_loop(Table);
    
    {search_by_company, Data} ->
      io:format("~w~n", [ets:match(Table, #person{name = '$1', location = '_', company = Data})]),
      db_loop(Table);

    {remove, Name}  ->
      db_loop(ets:delete(Table, Name));
    
    {all_names} ->
      io:format("~w~n", [ets:match(Table, #person{name = '$1', location = '_', company = '_'})]),
      db_loop(Table);
    
    {all_locations} ->
      io:format("~w~n", [lists:sort(ets:match(Table, #person{name = '_', location = '$1', company = '_'}))]),
      db_loop(Table);
    
    stop ->
      ets:delete(Table),
      exit("Bye!")
  end.
      
% User cli

help()  ->
  {db, ?SERVER} ! {help}.
      
insert(Name, Location, Company) ->
  {db, ?SERVER} ! {insert, Name, Location, Company}.

where_is(Name) ->
  {db, ?SERVER} ! {search_by_name, Name}.

located_at(Location)  ->
  {db, ?SERVER} ! {search_by_location, Location}.
  
working_at(Name)  ->
  {db, ?SERVER} ! {search_by_company, Name}.

remove(Name)  ->
  {db, ?SERVER} ! {remove, Name}.

all_names() ->
  {db, ?SERVER} ! {all_names}.

all_locations() ->
  {db, ?SERVER} ! {all_locations}.
  
% Client

start_client()  ->
  case net_adm:ping(?SERVER) of
    pong  ->
      io:format("Connection to ~w is established!~n", [?SERVER]),
      to_start_client();
    pang  ->
      io:format("The server doesn't exist!~n")
  end.

to_start_client() ->	
	register(client,  spawn(?MODULE, loop_client, [])),
	register(monitor, spawn_link(?MODULE, loop_monitor, [])).

stop_client()   ->
  client ! stop.

loop_client() ->
	receive
		stop ->
			exit("Finish");			

		ok ->
			io:format("ok~n", []),
			loop_client();
	end. 