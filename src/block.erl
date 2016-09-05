-module(block).
-export([]).
-record(block, {height, prev_hash, txs, channels, constants, census, pays_burn, number, entropy}).%tries: txs, channels, constants, census, 
%this gets wrapped in a signature from the pays_burn person, and then wrapped in a pow.

%new_block() ->
    %ModeRoot is a datastructure containing a bunch of constants that define the protocol. This way validators can have an election process to adjust these constants over time.
    %ValidatorSignatureRoot is the datastructure that full nodes only do statistical verification of. They don't download the whole thing. It contains signatures of a significant fraction of validators. They sign over a recent blockhash.

