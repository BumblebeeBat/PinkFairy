-module(governance_variables).
-compile(export_all).

%these variables define how the consensus protocol works. At every height, the validators modify them slightly, so that the blockchain can adapt to its conditions.
%when we process a vote transaction, we make an update. the vote transaction is big, it says an optimal number for each value. The update is small, it only says a 1 or -1.
%combining updates is simple, just increment then all by one.

-record(vars, {
	  finality_blocks,
	  pow_per_block,
	  create_block_burn, 
	  create_account_cost, 
	  delete_account_reward, 
	  create_channel_cost, 
	  delete_channel_reward,
	  block_size_limit,
	  validators_per_block,
	  account_rent,
	  channel_rent,
	  oracle_delay_1,
	  oracle_delay_2,
	  difficulty}).
combine_updates(A, B) ->
    X = [A, B, #vars{}],
    Y = lists:map(fun(Foo) -> tl(tuple_to_list(Foo)) end, X),
    C = hd(Y),
    D = hd(tl(Y)),
    L = length(C),
    L = length(D),
    L = length(hd(tl(tl(Y)))),
    list_to_tuple([hd(A)|map_add(C, D)]).
map_add([], []) -> [];
map_add([H|T], [I|U]) -> [(H+I)|map_add(T, U)].
list_to_vars(T) ->
    list_to_tuple([vars|T]).
vars_to_list(V) ->
    tl(tuple_to_list(V)).

adjust(Values, Friction, DValues, DFriction) ->
    V = vars_to_list(Values),
    F = vars_to_list(Friction),
    DV = tuple_to_list(DValues),
    DF = tuple_to_list(DFriction),
    FF = hd(V),
    {NewV, NewF} = adjust2(V, F, DV, DF, FF, [], []),
    {list_to_vars(flip(NewV)), list_to_vars(flip(NewF))}.
flip(X) -> flip(X, []).
flip([X|T], Y) -> flip(T, [X|Y]).
    
adjust2([],[],[],[],_,V,F) -> {V, F};
adjust2([V|Vals],[F|Fric],[DV|DVals],[DF|DFric],Slippery,NewV,NewF) -> 
    ok = case DV of
	     -1 -> ok;
	     1 ->ok
	 end,
    true = frac:gt(DF, Slippery),
    true = frac:lt(DF, frac:divide(1, Slippery)),
    NV = frac:add(frac:mul(F, DV), V),
    NF = frac:mul(F, DF),
    adjust2(Vals, Fric, DVals, DFric, Slippery,[NV|NewV],[NF|NewF]).
channel_rent(X) ->
    X#vars.channel_rent.
account_rent(X) ->
    X#vars.account_rent.
validators_per_block(X) ->
    X#vars.validators_per_block.
census_per_block(X) ->
    X#vars.census_per_block.
block_size_limit(X) ->
    X#vars.block_size_limit.
delete_channel_reward(X) ->
    X#vars.delete_channel_reward.
create_channel_cost(X) ->
    X#vars.create_channel_cost.
delete_account_reward(X) ->
    X#vars.delete_account_reward.
create_account_cost(X) ->
    X#vars.create_account_cost.
create_block_pow(X) ->
    X#vars.create_block_pow.
create_block_cost(X) ->
    X#vars.create_block_cost.
mininum_oracle_lifespan(X) ->
    X#vars.minimum_oracle_lifespan.
path(finality_blocks) -> 0;
path(pow_per_block) -> 1;
path(create_block_burn) -> 2;
path(create_account_cost) -> 3;
path(delete_account_reward) -> 4;
path(create_channel_cost) -> 5;
path(delete_channel_reward) -> 6;
path(block_size_limit) -> 7;
path(validators_per_block) -> 8;
path(account_rent) -> 9;
path(channel_rent) -> 10;
path(oracle_delay_1) -> 11;
path(oracle_delay_2) -> 12;
path(difficulty) -> 13.
update_size() -> 14.
    
first_var_root() ->
    %These should all probably be in scientific notation, so we can have more range of values for less memory requirement.
    X = 65536,
    Var = #var{finality_blocks = X,%400
	       pow_per_block = X, %
	       create_block_burn = X, %
	       create_account_cost = X, %
	       delete_account_reward = X, %
	       create_channel_cost = X,
	       delete_channel_reward = X,
	       block_size_limit = X, % two megabytes
	       validators_per_block = X, % 32
	       account_rent = X, %
	       channel_rent = X,
	       oracle_delay_1 = X,
	       oracle_delay_2 = X,
	       difficulty = X},
    store(Var, 0).
store(Var, Root) ->
    L = tl(tuple_to_list(Var)),
    store2(0, L, Root).
store2(_, [], Root) -> Root.
store2(N, [H|T], Root) ->
    trie:put(N, Root, 0, variables), 
    ok.
    
    

	 
