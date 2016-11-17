-module(pink_fairy_sup).
-behaviour(supervisor).
-export([start_link/1,init/1,stop/0]).%,start_http/0]).
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).
start_link(Amount) -> supervisor:start_link({local, ?MODULE}, ?MODULE, [Amount]).
%-define(keys, [keys, accounts, channels, block_dump, block_pointers, block_finality, secrets, entropy, all_secrets, port, block_tree, tx_pool, inbox, mail, arbitrage, tx_pool_feeder, channel_manager, channel_manager_feeder, channel_partner]).
-define(keys, [entropy_maker, keys, port]).

child_maker([]) -> [];
child_maker([H|T]) -> [?CHILD(H, worker)|child_maker(T)].
child_killer([]) -> [];
child_killer([H|T]) -> 
    supervisor:terminate_child(pink_fairy_sup, H),
    child_killer(T).
stop() -> 
    child_killer(?keys),
    halt().
%exit(keys, kill).
%supervisor:terminate_child(pink_fairy_sup, keys).
init([Amount]) ->
    io:fwrite("pink fairy sup init\n"),
    %Max = round(math:pow(2, constants:acc_bits())),
    KeyLength = 5,% round(math:pow(16, keylength
    true = Amount < math:pow(16, KeyLength),
    Children = [
		{accounts_sup, {trie_sup, start_link, [constants:account_size(), KeyLength, constants:account_size(), accounts, Amount, hd]}, permanent, 5000, supervisor, [trie_sup]},
		{channels_sup, {trie_sup, start_link, [constants:channel_size(), KeyLength, constants:channel_size(), channels, Amount, hd]}, permanent, 5000, supervisor, [trie_sup]},
		{variables_sup, {trie_sup, start_link, [constants:variable_size(), KeyLength, constants:channel_size(), variables, constants:many_variables(), hd]}, permanent, 5000, supervisor, [trie_sup]},
		{census_sup, {trie_sup, start_link, [constants:vote_tx_size(), KeyLength, constants:channel_size(), census, Amount, hd]}, permanent, 5000, supervisor, [trie_sup]}
	       ] ++ child_maker(?keys),
    {ok, { {one_for_one, 5, 10}, Children} }.

