-module(block).
-export([hash/1, check/4, test/0]).
-record(block, {height, prev_hash, txs, votes, channels, accounts, variables, mines_block}).%tries: txs, channels, census, 
%prev_hashes is a list that points to: 1 block ago, 2 blocks ago, 4 blocks ago, 8 blocks ago ... all the way back to the earliest block possible. That way we can efficiently look up old blocks.
%because we delete old blocks, and we don't point to deleted blocks, this list will be log2(number of blocks we remember) long.
%this gets wrapped in a signature from the pays_burn person, and then wrapped in a pow.

%new_block() ->
    %ModeRoot is a datastructure containing a bunch of constants that define the protocol. This way validators can have an election process to adjust these constants over time.
    %ValidatorSignatureRoot is the datastructure that full nodes only do statistical verification of. They don't download the whole thing. It contains signatures of a significant fraction of validators. They sign over a recent blockhash.

hash(Block) ->
    B2 = term_to_binary(Block),
    hash:doit(B2).

check(PowBlock, _Seed, _Votes, Prev) ->
    %Check that Prev is a valid block in our memory!!
    VarsRoot = Prev#block.variables,
    {_, Difficulty, _Proof} = get:get(variables:path(difficulty), VarsRoot, variables),%we are assuming that all the proofs were read in at a previous step, so we are now able to query them.
    %true = verify:proof(VarsRoot, Difficulty, Proof, CFG),
    pow:above_min(PowBlock, Difficulty),%difficulty is in the variables trie.
    Block = pow:data(PowBlock),
    true = (block:height(Block)-1) == block:height(Prev),
    H = hash(Prev),
    H = Block#block.prev_hash,
    X = {Block#block.channels, Block#block.accounts, Block#block.variables},
    X = txs:digest(Block#block.txs, 
		   Prev#block.channels,
		   Prev#block.accounts,
		   Prev#block.variables),
    %enough vote transactions
    %check sample of votes from vote trie to calculate the weight
    ok.


test() ->
    
    ok.
