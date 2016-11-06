-module(spend_tx).
-export([doit/2, spend/4]).
-record(spend, {from = 0, nonce = 0, to = 0, amount = 0, fee = 0}).
spend(To, Amount, Fee, Id) ->
    Acc = block_tree:account(Id),
    #spend{from = Id, nonce = accounts:nonce(Acc) + 1, to = To, amount = Amount, fee = Fee}.
doit(Tx, Channels, Accounts, Variables, Height, Return) ->
    From = Tx#spend.from,
    false = From == Tx#spend.to,
    U = account:new_update(Tx#spend.to, Tx#spend.amount, [], Height, []),
    T = account:new_update(Tx#spend.from, -Tx#spend.amount-Tx#spend.fee, [Tx#spend.nonce], Height, []),
    Return ! {[], [U,T], []}.%channels, accounts, variables

%doit(Tx, ParentKey, Channels, Accounts, TotalCoins, S, NewHeight) ->
%    From = Tx#spend.from,
%    false = From == Tx#spend.to,
%    To = block_tree:account(Tx#spend.to, ParentKey, Accounts),
%    F = block_tree:account(Tx#spend.from, ParentKey, Accounts),
%    A = Tx#spend.amount,
%    NT = accounts:update(To, NewHeight, A, 0, 0, TotalCoins),
%    NF = accounts:update(F, NewHeight, -A - Tx#spend.fee, 0, 1, TotalCoins),
%    Nonce = accounts:nonce(NF),
%    Nonce = Tx#spend.nonce,
%    Accounts2 = dict:store(Tx#spend.to, NT, Accounts),
%    {Channels, dict:store(Tx#spend.from, NF, Accounts2), TotalCoins, S}.
