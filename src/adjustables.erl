-module(adjustables).
-compile(export_all).

%You can edit these constants to customize the functionality of your machine

trie_size() -> 100000.%This is the maximum number of things you can store in your trie. You need this to be big enough to store everything you want long-term, and it needs to be big enough to store all the updates made in any single block.
%Warning, storing a single account can consume multiple units. Because it is a trie, and every step of the trie leading to your data is another unit.

%census_size() ->
    %can be as big as the number of users times the number of times they voted since finality.
    %in order to make blocks, it needs to be at least as big as the number of users.
%    1000.
