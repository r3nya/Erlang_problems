-module(testcase).
-export([run/0]).

run() ->
  db_rec:start(),
    
  receive
	  after
	    500 ->
		    true
	end,
    
  R1 = (catch db_rec:insert(lydia, home, telia)),
  io:format("insert(lydia, home, telia) => ~p~n", [R1]),
    
  R2 = (catch db_rec:insert(lydia, home, alcatel)),
  io:format("insert(lydia, home, alcatel) => ~p~n", [R2]),
    
  R3 = (catch db_rec:insert(leanne, home, mannesman)),
  io:format("insert(leanne, home, mannesman) => ~p~n", [R3]),
    
  R4 = (catch db_rec:insert(livia, work, bt)),
  io:format("insert(livia, work, bt) => ~p~n", [R4]),
    
  R5 = (catch db_rec:where_is(leanne)),
  io:format("where_is(leanne) => ~p~n", [R5]),
    
  R6 = (catch db_rec:located_at(home)),
  io:format("located_at(home) => ~p~n", [R6]),
    
  R7 = (catch db_rec:located_at(school)),
  io:format("located_at(school) => ~p~n", [R7]),
    
  R8 = (catch db_rec:remove(leanne)),
  io:format("remove(leanne) => ~p~n", [R8]),

  R9 = (catch db_rec:where_is(leanne)),
  io:format("where_is(leanne) => ~p~n", [R9]),
    
  db_rec:stop().
