-module(constants).
-compile(export_all).

balance_bits() -> 48.%total number of coins is 2^(balance_bits()).
acc_bits() -> 40.%total number of accounts is 2^(acc_bits()) 800 billion.
height_bits() -> 32. %maximum number of blocks is 2^this
account_nonce_bits() -> 20.%maximum number of times you can update an account's state is 2^this.
channel_nonce_bits() -> 30.%maximum number of times you can update a channel's state is 2^this.
channel_type_bits() -> 1.
channel_timeout_bits() -> 1.
    
-define(AccountSizeWithoutPadding, balance_bits() + height_bits() + account_nonce_bits() + (2*merkle_constants:hash_depth())).
-define(ChannelSizeWithoutPadding, (acc_bits()*2) + (balance_bits()*2) + channel_nonce_bits() + height_bits() + channel_type_bits() + channel_timeout_bits()).
account_padding() ->    
    (8 - (?AccountSizeWithoutPadding rem 8) rem 8).
channel_padding() ->
    (8 - (?ChannelSizeWithoutPadding rem 8) rem 8).
account_size() ->    
    ?AccountSizeWithoutPadding + account_padding().
channel_size() ->    
    ?ChannelSizeWithoutPadding + channel_padding().
entropy_file() -> "data/entropy_file.db".
