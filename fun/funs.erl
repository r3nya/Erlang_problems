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

% 7.C

all(Pred, [])   ->
        true;
all(Pred, [H|T] ->
        case Pred(H) of
                true    ->      all(Pred, T);
                false   ->      false
        end.

all_even(List)  ->
        all(fun(X)      ->      X rem 2 == 0 end, List).

first(Pred, []) ->
        false;
first(Pred, [Head|Tail])        ->
        case Pred(Head) of
                true    ->      Head;
                false   ->      first(Pred, Tail)
        end.

% 7.D

mk_adder(Const) ->
        fun(X)  ->      X + Const end.
