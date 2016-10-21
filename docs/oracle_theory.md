Projects like Truthcoin and Augur are trying to add more information into the consensus state of a blockchain.
[The bad way to do this is to write a consensus mechanism on top of your consensus mechanism](consensus_layering.md)
.
The good way to do this is to repurpose the one consensus mechanism to do both things.

In Pink Fairy, consensus state changes all have majority value-holder approval.
If a state change destroys more value than it creates, the majority will reject it.
So each of the 2 consensus mechanisms are ultimately measuring the opinion of the same distribution of users.

Either 1 consensus mechanism is better for asking the opinion of the distribution, or the other is better. There is no reason to have both.

Look at how the DAO made Ethereum split into 2 pieces.
This is because the outcome of where the DAO sent money wasn't being controlled by the same consensus mechanism as ethereum.
So the majority of users who controlled the consensus mechanism decided to do a fork.
The DAO was a fancy kind of oracle which came to decisions based on the input of it's users.
In order to avoid events like this, we need to make sure that the same distribution that controls the blockchain consensus should also control the oracle's decisions.
