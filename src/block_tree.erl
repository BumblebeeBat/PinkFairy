-module(block_tree).

%We need to remember a list of all the merkle roots we care about so that we can garbage collect the trie

%maybe it should be a ram map between the hash of a block and it's location on the hard drive. But, that makes deleting blocks annoying.
%We could make each block a seperate file on the hard drive. then deleting would be easy.

%Maybe this should all be in ram, and we only remember the 100 or so most recent blocks of <5 megabytes each.

%We should start by downloading a recently hashed block that the user inputs. From that we should download the rest of the blocks backwards, and then verify them forwards.

%If a fork gets too long, the node should give up and request a recent hash from the user.
-export([test/0]).
absorb(Block, PrevBlock) ->
    true = block:check(Block, PrevBlock),
    save(Block).
read(Hash) ->
    BF = binary_to_file(Hash),
    Z = db:read(BF),
    binary_to_term(zlib:uncompress(Z)).
binary_to_file(B) ->
    H = binary_to_list(B),
    "blocks/"++H++".db".
save(Block) ->
    Z = zlib:compress(term_to_binary(Block)),
    Hash = block:hash(Block),
    BF = binary_to_file(hash(Block)),
    db:save(BF, Z),
    Hash.
