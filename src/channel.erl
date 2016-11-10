-module(channel).
-export([new_channel/5,test/0,serialize/1,deserialize/1,update_channel/3]).

%This is the part of the channel that is written onto the hard drive.

-record(channel, {id = 0, acc1 = 0, acc2 = 0, bal1 = 0, bal2 = 0, 
		  nonce = 0,%How many times has this channel-state been updated. If your partner has a state that was updated more times, then they can use it to replace your final state.
		  rent = 0,
		  rent_direction = 0,
		  timeout_height = 0,
		  last_modified = 0}).%,%when one partner disappears, the other partner needs to wait so many blocks until they can access their money. This records the time they started waiting. 
% we can set timeout_height to 0 to signify that we aren't in timeout mode. So we don't need the timeout flag.
		  %timeout = false}).
-record(update, {type = grow, inc1 = 0, inc2 = 0, nonce = 0, rent = 0, rent_direction = 0}).%type is either grow or close.

%maybe we should combine grow and close updates.
combine_updates(A, B) ->
    A#channel.type = grow,
    B#channel.type = grow,
    AN = A#channel.nonce,
    BN = B#channel.nonce,
    {Nonce, Rent, Direction} = 
	if
	    AN > BN -> {AN, A#channel.rent, A#channel.rent_direction};
	    BN > AN -> {BN, B#channel.rent, B#channel.rent_direction}
	end,
    #update{type = grow, 
	    inc1 = A#channel.inc1 + B#channel.inc1,
	    inc2 = A#channel.inc2 + B#channel.inc2,
	    nonce = Nonce, 
	    rent = Rent, 
	    rent_direction = Direction};
	    
    
update_channel(C, U, _Vars) ->
    C#channel{bal1 = C#channel.bal1 + U#update.inc1,
	      bal2 = C#channel.bal2 + U#update.inc2,
	      nonce = U#update.nonce,
	      rent = U#update.rent,
	      rent_direction = U#update.rent_direction}.
test() ->
    C = new_channel(0,1,2,3,-4),
    C = deserialize(serialize(C)).
new_channel(Acc1, Acc2, Bal1, Bal2, Rent) ->
    RS = if
	     (Rent > 0) -> 0;
	     true -> 1
	 end,
    #channel{acc1 = Acc1, acc2 = Acc2, bal1 = Bal1, bal2 = Bal2, rent = abs(Rent), rent_direction = RS}.

serialize(C) ->
    ACC = constants:acc_bits(),
    BAL = constants:balance_bits(),
    HEI = constants:height_bits(),
    NON = constants:channel_nonce_bits(),
    Rent = constants:channel_rent_bits(),
    Pad = constants:channel_padding(),
    %TYP = constants:channel_type_bits(),
    %TIM = constants:channel_timeout_bits(),
    %io:fwrite(C),
    << (C#channel.acc1):ACC,
       (C#channel.acc2):ACC,
       (C#channel.bal1):BAL,
       (C#channel.bal2):BAL,
       (C#channel.nonce):NON,
       (C#channel.timeout_height):HEI,
       (C#channel.rent):Rent,
       (C#channel.rent_direction):1,
       0:Pad>>.
       %(C#channel.type):TYP,
       %(C#channel.timeout):TIM>>.
deserialize(B) ->
    ACC = constants:acc_bits(),
    BAL = constants:balance_bits(),
    HEI = constants:height_bits(),
    NON = constants:channel_nonce_bits(),
    Rent = constants:channel_rent_bits(),
    Pad = constants:channel_padding(),
    %TYP = constants:channel_type_bits(),
    %TIM = constants:channel_timeout_bits(),
    << B1:ACC,
       B2:ACC,
       B3:BAL,
       B4:BAL,
       B5:NON,
       B6:HEI,
       B7:Rent,
       B8:1,
       _:Pad>> = B,
       %B7:TYP,
       %B8:TIM>> = B,
    #channel{acc1 = B1, acc2 = B2, bal1 = B3, bal2 = B4,
	     nonce = B5, timeout_height = B6,
	     rent = B7, rent_direction = B8}.%,
	     %type = B7, timeout = B8}.
    
    
