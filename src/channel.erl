-module(channel).
-export([new_channel/5,test/0,serialize/1,deserialize/1]).

%This is the part of the channel that is written onto the hard drive.

-record(channel, {acc1 = 0, acc2 = 0, bal1 = 0, bal2 = 0, called_timeout_nonce = 0, timeout_height = 0, type = 0, timeout = false}).
test() ->
    ok.
new_channel(Acc1, Acc2, Bal1, Bal2, Type) ->
    case Type of
	0 -> ok;
	1 -> ok
    end,
    #channel{acc1 = Acc1, acc2 = Acc2, bal1 = Bal1, bal2 = Bal2, type = Type}.

serialize(C) ->
    ACC = constants:acc_bits(),
    BAL = constants:balance_bits(),
    HEI = constants:height_bits(),
    NON = constants:channel_nonce_bits(),
    TYP = constants:channel_type_bits(),
    TIM = constants:channel_timeout_bits(),
    << (C#channel.acc1):ACC,
       (C#channel.acc2):ACC,
       (C#channel.bal1):BAL,
       (C#channel.bal2):BAL,
       (C#channel.called_timeout_nonce):NON,
       (C#channel.timeout_height):HEI,
       (C#channel.type):TYP,
       (C#channel.timeout):TIM>>.
deserialize(B) ->
    ACC = constants:acc_bits(),
    BAL = constants:balance_bits(),
    HEI = constants:height_bits(),
    NON = constants:channel_nonce_bits(),
    TYP = constants:channel_type_bits(),
    TIM = constants:channel_timeout_bits(),
    << B1:ACC,
       B2:ACC,
       B3:BAL,
       B4:BAL,
       B5:NON,
       B6:HEI,
       B7:TYP,
       B8:TIM>> = B,
    #channel{acc1 = B1, acc2 = B2, bal1 = B3, bal2 = B4,
	     called_timeout_nonce = B5, timeout_height = B6,
	     type = B7, timeout = B8}.
    
    
