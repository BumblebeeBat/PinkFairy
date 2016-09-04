-module(block).
-export([new_block/7]).

new_block(_Height, _PrevHash, _TxsRoot, _AccountRoot, _ChannelRoot, _ModeRoot, _ValidatorSignatureRoot) ->
    %ModeRoot is a datastructure containing a bunch of constants that define the protocol. This way validators can have an election process to adjust these constants over time.
    %ValidatorSignatureRoot is the datastructure that full nodes only do statistical verification of. They don't download the whole thing. It contains signatures of a significant fraction of validators. They sign over a recent blockhash.
    ok.
