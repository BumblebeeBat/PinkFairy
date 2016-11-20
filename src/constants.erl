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
pow(_, 0) -> 1;
pow(A, 1) -> A;
pow(A, B) when (B rem 2) == 0 -> 
    pow(A*A, B div 2);
pow(A, B) ->
    A*pow(A, B-1).
initial_coins() ->
    pow(2, balance_bits()) - 1.
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
variable_size() -> 3. %bytes
vote_tx_size() ->
    5000. %5k bytes is the limit for how many things can be voted on at a time.
%we should probably update this datastructure to store arbitrary sized votes.
many_variables() ->
    5000.
first_addr() -> hash:doit(0).
    
first_acc_root() ->
    %start with the empty account trie. Insert the initial accounts.
    Revealed = hash:doit(1),
    Acc = account:new_account(first_addr(), initial_coins(), 0, 0, Revealed),
    ID = 0,
    Root = 0,
    account:overwrite(Root, Acc, ID).
    
    
