-module(block).
-export([hash/1, check/4, test/0]).
-record(block, {height, prev_hash, txs, votes, channels, accounts, variables, oracle_questions, oracle_answers, mines_block}).%tries: txs, channels, census, 
-define(Genesis, #block{height = 1, prev_hash = 0, txs = [], votes = 0, channels = 0, accounts = constants:first_acc_root(), oracle_questions = 0, oracle_answers = 0, variables = governance_variables:first_var_root()}).
%prev_hashes is a list that points to: 1 block ago, 2 blocks ago, 4 blocks ago, 8 blocks ago ... all the way back to the earliest block possible. That way we can efficiently look up old blocks.
%because we delete old blocks, and we don't point to deleted blocks, this list will be log2(number of blocks we remember) long.
%this gets wrapped in a signature from the pays_burn person, and then wrapped in a pow.

%new_block() ->
    %ModeRoot is a datastructure containing a bunch of constants that define the protocol. This way validators can have an election process to adjust these constants over time.
    %ValidatorSignatureRoot is the datastructure that full nodes only do statistical verification of. They don't download the whole thing. It contains signatures of a significant fraction of validators. They sign over a recent blockhash.

%besides POW for coin creation as a tx type in the block, we also need to charge some POW for creating the block as an anti-spam mechanism.

hash(Block) ->
    B2 = term_to_binary(Block),
    hash:doit(B2).

check(PowBlock, _Seed, _Votes, Prev) ->
    %Check that Prev is a valid block in our memory!!
    VarsRoot = Prev#block.variables,
    {_, Difficulty, _Proof} = trie:get(variables:path(difficulty), VarsRoot, variables),%we are assuming that all the proofs were read in at a previous step, so we are now able to query them.
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
		   Prev#block.variables,
		  []),%account updates. this is where we will delete some money and lock up some money of the user who created the block
    %enough vote transactions
    %check sample of votes from vote trie to calculate the weight
    ok.


test() ->
    
    ok.
