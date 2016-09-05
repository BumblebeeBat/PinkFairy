-module(account).
-export([serialize/1,deserialize/1,combine_updates/2,apply_update/2,new_account/4,new_update/5,test/0]).

-record(acc, {balance = 0, %amount of money you have
	      nonce = 0, %increments with every tx you put on the chain. 
	      height = 0,  %The last height at which you paid the tax
	      fork_height = 0, %The last height at which you selected a fork.
	      revealed = 0, 
	      addr = []}). %loc is our location in the accounts trie.
-record(update, {loc = -1, balance = 0, nonce = 0, height, revealed}).
%revealed is the most recently revealed entropy. Every revealed entropy needs to be the inverse hash of the previously revealed entropy

new_account(Balance, Nonce, Height, Revealed) ->
    #acc{balance = Balance, nonce = Nonce, height = Height, revealed = Revealed}.
new_update(Loc, DBalance, DNonce, Height, Revealed) ->
    #update{loc = Loc, balance = DBalance, nonce = DNonce, height = Height, revealed = Revealed}.

serialize(A) ->
    BAL = constants:balance_bits(),
    HEI = constants:height_bits(),
    R = A#acc.revealed,
    Addr = A#acc.addr,
    SizeR = size(R),
    SizeR = merkle_constants:hash_depth(),
    SizeAddr = size(Addr),
    SizeAddr = merkle_constants:hash_depth(),
    Nbits = constants:account_nonce_bits(),
    AP = constants:account_padding(),
    <<(A#acc.balance):BAL, 
      (A#acc.nonce):(Nbits), 
      (A#acc.height):HEI,
      (R)/binary,
      Addr/binary,
      0:AP>>.

deserialize(A) ->
    BAL = constants:balance_bits(),
    HEI = constants:height_bits(),
    HD = merkle_constants:hash_depth(),
    Nbits = constants:account_nonce_bits(),
    AP = constants:account_padding(),
    <<B1:BAL,
      B2:Nbits,
      B4:HEI,
      B5:HD,
      B6:HD,
      _:AP>> = A,
    #acc{balance = B1, nonce = B2, height = B4, revealed = <<B5:HD>>, addr = <<B6:HD>>}.
    
combine_updates(U1, U2) ->
    Loc = U1#update.loc,
    Loc = U2#update.loc,
    U1B = U1#update.balance,
    U2B = U2#update.balance,
    Balance = U1B + U2B,
    U1N = U1#update.nonce,
    U2N = U2#update.nonce,
    Nonce = U1N + U2N,
    U1H = U1#update.height,
    U2H = U2#update.height,
    U1R = U1#update.revealed,
    U2R = U2#update.revealed,
    Height = max(U1H, U2H),
    Revealed = 
	if
	    U1H > U2H ->
		U2R ++ U1R;
	    U2H > U1H ->
		U1R ++ U2R
	    end,
    #update{loc = Loc, balance = Balance, nonce = Nonce, height = Height, revealed = Revealed}.
    
apply_update(Acc, U) ->
    B = Acc#acc.balance,
    N = Acc#acc.nonce,
    H = Acc#acc.height,
    R = Acc#acc.revealed,
    A = Acc#acc.addr,
    UB = U#update.balance,
    UN = U#update.nonce,
    UH = U#update.height,
    UR = U#update.revealed,
    true = UH > H,
    true = UN > 0,
    LR = hash_chain([R] ++ UR),
    FB = B+UB,
    true = FB > 0,
    %we should add a check to make sure it has more than the minimum balance.
    %its ok for accounts to have negative balance, we just need to make sure that the cost of creating an account is bigger than the reward for gabage collecting it.
    %only people participating in the validator lottery have a minimum balance. They need to be able to afford to pay the expected amount of safety deposits.
    %this minimum includes money they have in safety deposits already.
    %How often they are selected is based on how much money they had finality ago. So there is a minimum ratio between the most money you had, and the least money you had in the last finality period.
    #acc{balance = FB, nonce = N+UN, height = UH, revealed = LR, addr = A}.

hash_chain([X]) -> X;
hash_chain([A|[B|T]]) -> 
    A = hash:doit(B),
    hash_chain([B|T]).


test() ->
    H1 = hash:doit(1),
    H2 = hash:doit(H1),
    H3 = hash:doit(H2),
    H4 = hash:doit(H3),
    hash_chain([H4, H3, H2, H1]),
    A = #acc{revealed = H4},
    U1 = #update{loc = 0, balance = 30, nonce = 1, height = 1, revealed = [H3]},
    U2 = #update{loc = 0, balance = -10, nonce = 1, height = 2, revealed = [H2]},
    A2 = apply_update(A, U1),
    A3 = {acc,20,2,2,
	  <<117,147,246,249,247,131,226,60,9,164,235,197>>,
	  []},
    A3 = apply_update(A2, U2),
    U3 = combine_updates(U1, U2),
    A3 = apply_update(A, U3).

    

    
