-module(block).
-export([]).
-record(block, {height, prev_hashes, txs, votes, channels_root, accounts_root, variables, census, pays_burn, entropy}).%tries: txs, channels, census, 
%prev_hashes is a list that points to: 1 block ago, 2 blocks ago, 4 blocks ago, 8 blocks ago ... all the way back to the earliest block possible. That way we can efficiently look up old blocks.
%because we delete old blocks, and we don't point to deleted blocks, this list will be log2(number of blocks we remember) long.
%this gets wrapped in a signature from the pays_burn person, and then wrapped in a pow.

%new_block() ->
    %ModeRoot is a datastructure containing a bunch of constants that define the protocol. This way validators can have an election process to adjust these constants over time.
    %ValidatorSignatureRoot is the datastructure that full nodes only do statistical verification of. They don't download the whole thing. It contains signatures of a significant fraction of validators. They sign over a recent blockhash.

check(Block, Prev, State) ->
    true = block:height(Block)-1 == block:height(PrevBlock),
    
