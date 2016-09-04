-module(pink_fairy_sup).
-behaviour(supervisor).
-export([start_link/0,init/1,stop/0]).%,start_http/0]).
-define(CHILD(I, Type), {I, {I, start_link, []}, permanent, 5000, Type, [I]}).
start_link() -> supervisor:start_link({local, ?MODULE}, ?MODULE, []).
%-define(keys, [keys, accounts, channels, block_dump, block_pointers, block_finality, secrets, entropy, all_secrets, port, block_tree, tx_pool, inbox, mail, arbitrage, tx_pool_feeder, channel_manager, channel_manager_feeder, channel_partner]).
-define(keys, [entropy_maker]).

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
init([]) ->
    io:fwrite("pink fairy sup init\n"),
    Max = round(math:pow(2, constants:acc_bits())),
    Children = [
		{accounts_sup, {trie_sup, start_link, [constants:account_size(), Max, accounts]}, permanent, 5000, supervisor, [trie_sup]},
		{channels_sup, {trie_sup, start_link, [constants:channel_size(), Max, channels]}, permanent, 5000, supervisor, [trie_sup]}
	       ] ++ child_maker(?keys),
    {ok, { {one_for_one, 5, 10}, Children} }.

