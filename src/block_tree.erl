-module(block_tree).
-behaviour(gen_server).

%We need to remember a list of all the merkle roots we care about so that we can garbage collect the trie

%maybe it should be a ram map between the hash of a block and it's location on the hard drive. But, that makes deleting blocks annoying.
%We could make each block a seperate file on the hard drive. then deleting would be easy.

%Maybe this should all be in ram, and we only remember the 100 or so most recent blocks of <5 megabytes each.

%We should start by downloading a recently hashed block that the user inputs. From that we should download the rest of the blocks backwards, and then verify them forwards.

%If a fork gets too long, the node should give up and request a recent hash from the user.

-export([start_link/0,code_change/3,handle_call/3,handle_cast/2,handle_info/2,init/1,terminate/2]).
init(ok) -> {ok, []}.
start_link() -> gen_server:start_link({local, ?MODULE}, ?MODULE, ok, []).
code_change(_OldVsn, State, _Extra) -> {ok, State}.
terminate(_, _) -> io:format("died!"), ok.
handle_info(_, X) -> {noreply, X}.
handle_cast(_, X) -> {noreply, X}.
handle_call(_, _From, X) -> {reply, X, X}.

absorb(Block, State) ->
    true = block_checker(Block, State),
    gen_server:call(?MODULE, {absorb, Block, State)).
