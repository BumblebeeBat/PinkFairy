-module(pink_sign).
-export([test/0]).

sign(_Tx, _Sigs, _Pubs, _Priv) ->
    %find out with spot we sign, and if we haven't yet signed it, then sign it. Return signed tx.
    %make sure that pubs forms the address expected in Tx.
    ok.
verify(_Tx) ->
    ok.

test() ->
    Tx = 0,
    STx = sign(Tx, [], [], []),
    verify(STx),
    ok.
