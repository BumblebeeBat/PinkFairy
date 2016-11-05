-module(test_test).
-export([test/0]).

func(_X) ->
    5.

map(_, []) -> [];
map(F, [A|T]) -> 
    [F(A)|map(F, T)].


test() ->
    map(func, [0,1,2,3,4]).
