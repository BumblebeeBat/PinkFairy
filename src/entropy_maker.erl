-module(entropy_maker).
-behaviour(gen_server).
-export([start_link/0,code_change/3,handle_call/3,handle_cast/2,handle_info/2,init/1,terminate/2, get/1]).
-define(EntropyFile, constants:entropy_file()).
init(ok) -> 
    %if possible load existing library, otherwise write a new one.
    Z = case db:read(?EntropyFile) of
	    "" ->
		K = make(),
		db:save(?EntropyFile, K),
		K;
	X -> X
    end,
    {ok, Z}.
start_link() -> gen_server:start_link({local, ?MODULE}, ?MODULE, ok, []).
code_change(_OldVsn, State, _Extra) -> {ok, State}.
terminate(_, X) -> 
    db:save(?EntropyFile, X),
    io:format("entropy_maker died!"), ok.
handle_info(_, X) -> {noreply, X}.
handle_cast(_, X) -> {noreply, X}.
handle_call({get, N}, _From, X) -> 
    {reply, element(N, X), X}.

get(N) -> gen_server:call(?MODULE, {get, N}).

make() ->
    X = crypto:strong_rand_bytes(100),
    %Many = round(math:pow(2, constants:account_nonce_bits())),
    Many = 100000,%takes too long otherwise
    hashes(hash:doit(X), Many, []).
hashes(_, 0, X) -> list_to_tuple(X);
hashes(X, N, L) -> 
    hashes(hash:doit(X), N-1, [X|L]). 
