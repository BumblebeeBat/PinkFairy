-module(constants).
-compile(export_all).

keys() -> "data/keys.db".

balance_bits() -> 48.%total number of coins is 2^(balance_bits()).
acc_bits() -> trie_hash:hash_depth()*8.%total number of accounts is 2^(acc_bits()) 800 billion.
height_bits() -> 32. %maximum number of blocks is 2^this
account_nonce_bits() -> 20.%maximum number of times you can update an account's state is 2^this.
channel_nonce_bits() -> 30.%maximum number of times you can update a channel's state is 2^this.
channel_rent_bits() ->
    30.%So at the highest rent, if you had about 1024 channels open in parallel. it would take about 512 blocks to cost all the rent in the system.
%channel_type_bits() -> 1.
%channel_timeout_bits() -> 1.

address_entropy() -> trie_hash:hash_depth() * 8.
    
-define(AccountSizeWithoutPadding, (balance_bits() + height_bits() + account_nonce_bits() + (2*acc_bits()))).
-define(ChannelSizeWithoutPadding, ((acc_bits()*2) + (balance_bits()*2) + channel_nonce_bits() + height_bits() + channel_rent_bits() + 1)).
account_padding() ->    
    8 - (?AccountSizeWithoutPadding rem 8).
channel_padding() ->
    8 - (?ChannelSizeWithoutPadding rem 8).
account_size() ->    
    ?AccountSizeWithoutPadding + account_padding().
channel_size() ->    
    ?ChannelSizeWithoutPadding + channel_padding().
entropy_file() -> "data/entropy_file.db".

%====== Below this line, you can edit the constants to customize functionality on your machine. =========

trie_size() -> 100000.%This is the maximum number of things you can store in your trie. You need this to be big enough to store everything you want long-term, and it needs to be big enough to store all the updates made in any single block.
%Warning, storing a single account can consume multiple units. Because it is a trie, and every step of the trie leading to your data is another unit.
