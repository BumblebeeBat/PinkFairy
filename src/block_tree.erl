-module(block_tree).
-export([]).

%We need to remember a list of all the merkle roots we care about so that we can garbage collect the trie
