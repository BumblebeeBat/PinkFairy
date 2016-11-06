-module(node_configuration).
-export([doit/1]).

doit(trie_size) ->
    10000. %so we can adjust 10000 accounts per block.
