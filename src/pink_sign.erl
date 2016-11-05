-module(pink_sign).
-export([test/0]).

sign(Tx, Sigs, Pubs, Priv) ->
    %find out with spot we sign, and if we haven't yet signed it, then sign it. Return signed tx.
    %make sure that pubs forms the address expected in Tx.
    ok.
verify(Tx) ->
    
