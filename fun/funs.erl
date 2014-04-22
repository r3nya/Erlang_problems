-module('funs').
-compile(export_all).

% 7.A

calculate(X) ->
  F = fun() -> X * 2 end,
  F().
  
% 7.B

llen(List) ->
  lists:map(fun(X) when is_list(X) == true -> length(X) end, List).

min(L) ->
    lists:foldl(fun(X, Min) ->
                    case Min < X of
                        true    -> Min;
                        false   -> X
                    end
                end,
                hd(L), L).
