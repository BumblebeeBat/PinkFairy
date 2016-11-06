%each tx with a fee needs a to reference a recent hash. Everyone needs to be incentivized to make the hash as recent as possible.

%since updates to accounts can be merged, we should process all the txns in parallel. 
%step 1 is to verify that all the account proofs are valid to the state root. This is parallel.
%step 2 is to is to process all the txs. this is parallel. 
%step 3 is to update the accounts and channels in the trie.

-module(txs).
-behaviour(gen_server).
-export([start_link/0,code_change/3,handle_call/3,handle_cast/2,handle_info/2,init/1,terminate/2, dump/0,txs/0,digest/4,test/0]).
init(ok) -> {ok, []}.
start_link() -> gen_server:start_link({local, ?MODULE}, ?MODULE, ok, []).
code_change(_OldVsn, State, _Extra) -> {ok, State}.
terminate(_, _) -> io:format("txs died!"), ok.
handle_info(_, X) -> {noreply, X}.

handle_call(txs, _From, X) -> {reply, X, X}.
handle_cast(dump, _) -> {noreply, []};
handle_cast({add_tx, Tx}, X) -> {noreply, [Tx|X]}.
dump() -> gen_server:cast(?MODULE, dump).
txs() -> gen_server:call(?MODULE, txs).
to_lists([]) -> [];
to_lists([H|T]) -> [[H]|to_lists(T)].
sort_compress(L, Combine, Value) ->
    L2 = to_lists(L),
    sort_compress2(L2, Combine, Value).
sort_compress2([X], _, _) -> X;
sort_compress2(L, C, V) -> 
    L2 = sort_compress3(L, C, V),
    sort_compress2(L2, C, V).
sort_compress3([L], _, _) -> [L];
sort_compress3([], _, _) -> [];
sort_compress3([A|[B|T]], Combine, Value) -> 
    C = sort_compress_merge(A, B, [], Combine, Value),
    [C|sort_compress3(T, Combine, Value)].
sort_compress_merge(A, [], C, _, _) -> lists:reverse(A) ++ C;
sort_compress_merge([], B, C, _, _) -> lists:reverse(B) ++ C;
sort_compress_merge([H|T], [B|S], C, Combine, Value) -> 
    V1 = Value(H),
    V2 = Value(B),
    D = hd(C),
    V3 = Value(D),
    {X, Y, Z} = if
	V3 == V1-> 
	    {T, [B|S], [Combine(D, H)|tl(C)]};
	V2 == V1 -> 
	    {[H|T], S, [Combine(D, B)|tl(C)]};
	V1 > V2 -> {T, [B|S], [H|C]};
	V1 < V2 -> {[H|T], S, [B|C]};
	(V1 == V2) and (V3 == V1)-> 
	    {T, [B|S], [Combine(H, D)|tl(C)]};
	V1 == V2 ->
	    {[Combine(H, B)|T], S, C}
    end,
    sort_compress_merge(X, Y, Z, Combine, Value).
apply_updates([], MerkleRoot) -> MerkleRoot;
apply_updates([H|T], Root) -> 
    NewRoot = apply_update(H, Root),
    apply_updates(T, NewRoot).
apply_update(_Stuff, _Root) ->
    %use the included proof to calculate the new root.
    ok.
    
digest(Txs, Channels, Accounts, Variables) ->
    {ChannelUpdates, AccountUpdates, VariableUpdates} = 
	digest2(Txs, Channels, Accounts, Variables),
    %The previous line should be parallelized, then the results
    %appended before we start the sort_compress
    CU = sort_compress(ChannelUpdates, 
		       fun(X, Y) -> channel:combine_updates(X, Y) end, 
		       fun(X) -> channel:id(X) end),
    AU = sort_compress(AccountUpdates, 
		       fun(X, Y) -> account:combine_updates(X, Y) end,
		       fun(X) -> account:id(X) end),
    VU = sort_compress(VariableUpdates, 
		       fun(X, Y) -> variables:combine_updates(X, Y) end,
		       fun(X) -> variables:id(X) end),
    {apply_updates(CU, Channels),
     apply_updates(AU, Accounts),
     apply_updates(VU, Variables)}.
digest2(Txs, Channels, Accounts, Variables) ->    
    digest2(Txs, Channels, Accounts, Variables, [], [], []).
digest2([], _, _, _, CU, AU, VU) -> {CU, AU, VU};
digest2([SignedTx|Txs], Channels, Accounts, Variables, CU, AU, VU) ->
    true = sign:verify(SignedTx, Accounts),
    Tx = sign:data(SignedTx),
    Type = element(1, Tx),
    spawn(Type, doit, [Tx, Channels, Accounts, Variables, Height, self()]),%I used spawn here because the if conditional for all 20 types of functions was too much typing.
    receive 
	{NewCUs, NewAUs, NewVUs} -> 
	    digest2(Txs, Channels, Accounts, Variables, CU++NewCUs, AU++NewAUs, VU++NewVUs)
    end.

test() -> 0.
