-module(spend_tx).
-export([doit/6, spend/6]).
-record(spend, {from = 0, nonce = 0, to = 0, amount = 0, fee = 0}).
spend(To, Amount, Fee, Id, Accounts) ->
    %accounts is a pointer to the root of the current accounts trie.
    {_, Acc, Proof} = trie:get(Id, Accounts, accounts),
    {_, _Acc2, Proof2} = trie:get(To, Accounts, accounts),
    Tx = #spend{from = Id, nonce = account:nonce(Acc) + 1, to = To, amount = Amount, fee = Fee},
    {Tx, [Proof, Proof2]}
doit(Tx, Channels, Accounts, Variables, Height, Return) ->
    From = Tx#spend.from,
    false = From == Tx#spend.to,
    A = Tx#spend.amount,
    U = account:new_update(Tx#spend.to, A, [], Height, []),
    T = account:new_update(Tx#spend.from, -A-Tx#spend.fee, [Tx#spend.nonce], Height, []),
    Return ! {[], [U,T], []}.%channels, accounts, variables
