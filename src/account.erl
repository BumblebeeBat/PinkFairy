-module(account).
-export([serialize/1,deserialize/1,combine_updates/2,apply_update/3,new_account/4,new_update/5,nonce/1, test/0]).

-record(acc, {balance = 0, %amount of money you have
	      nonce = 0, %increments with every tx you put on the chain. 
	      height = 0,  %The last height at which you paid the tax
	      revealed = 0, %The last entropy you revealed. Every new entropy must be the inverse hash of the previous.
	      addr = []}). %addr is the hash of the public key we use to spend money.
-record(update, {id = -1, 
		 balance = 0, %how much money you gained
		 nonce = 0, %highest nonce value consumed, or [] for no nonce consumed
		 height, 
		 revealed}).
%revealed is the most recently revealed entropy. Every revealed entropy needs to be the inverse hash of the previously revealed entropy

new_account(Balance, Nonce, Height, Revealed) ->
    #acc{balance = Balance, nonce = Nonce, height = Height, revealed = Revealed}.
new_update(Id, DBalance, Nonce, Height, Revealed) ->
    #update{id = Id, balance = DBalance, nonce = [Nonce], height = Height, revealed = Revealed}.
nonce(X) -> X#acc.nonce.
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
    Id = U1#update.id,
    Id = U2#update.id,
    U1B = U1#update.balance,
    U2B = U2#update.balance,
    Balance = U1B + U2B,
    U1N = U1#update.nonce,
    U2N = U2#update.nonce,
    Nonce = if
		U1N == [] -> U2N;
		U2N == [] -> U1N;
		true -> max(U2N, U1N)
	    end,
    U1H = U1#update.height,
    U2H = U2#update.height,
    Height = max(U1H, U2H),
    H1 = U1#update.revealed, 
    H2 = U2#update.revealed, 
    H12 = trie_hash:doit(H1),
    H22 = trie_hash:doit(H2),
    Revealed = 
	if
	    H1 == H22 -> H1;
	    H2 == H12 -> H2
	end,
    #update{id = Id, balance = Balance, nonce = Nonce, height = Height, revealed = Revealed}.
    
apply_update(Acc, U, Vars) ->
    AccountRent = variables:account_rent(Vars),
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
    FB = B+UB - (AccountRent * (UH - H)),
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
    U1 = #update{id = 0, balance = 30, nonce = 1, height = 1, revealed = [H3]},
    U2 = #update{id = 0, balance = -10, nonce = 1, height = 2, revealed = [H2]},
    A2 = apply_update(A, U1, []),
    A3 = {acc,20,2,2,
	  <<117,147,246,249,247,131,226,60,9,164,235,197>>,
	  []},
    A3 = apply_update(A2, U2, []),
    U3 = combine_updates(U1, U2),
    A3 = apply_update(A, U3, []).
