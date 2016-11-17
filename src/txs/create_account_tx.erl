-module(create_account_tx).
-export([doit/6, create_account/5]).
-record(ca, {from = 0, nonce = 0, address = <<"">>, amount = 0, fee = 0}).

create_account(Addr, Amount, Fee, Id, Accounts) ->
    A = if
	    size(Addr) > 85 -> sign:pubkey2address(Addr);
	    true -> Addr
	end,
    {_, Acc, Proof} = trie:get(Id, Accounts, accounts),
    Tx = #ca{from = Id, nonce = accounts:nonce(Acc) + 1, address = A, amount = Amount, fee = Fee},
    {Tx, [Proof]}.
    
doit(Tx, _Channels, _Accounts, _Variables, Height, Return) ->
    %find out the fee for creating an account in variables, and charge it.
    A = Tx#ca.amount,
    U = account:new_update(Tx#ca.from, -A-Tx#ca.fee, [Tx#ca.nonce], Height, []),
    T = account:new_update(-1, A, [], Height, []),%-1 is so it doesn't crash the sorter. it means to create a new account.
    %Addr = Tx#ca.address,
    Return ! {[], [U,T], []}. %channels, accounts, variables


