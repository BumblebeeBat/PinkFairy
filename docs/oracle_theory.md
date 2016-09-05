Projects like Truthcoin and Augur are trying to add more information into the consensus state of a blockchain.
The bad way to do this is to write a consensus mechanism on top of your consensus mechanism.
Consensus mechanisms are terribly complicated protocols, writing them inside of each other is difficult to do, and difficult to maintain.
The good way to do this is to repurpose the one consensus mechanism to do both things.

For any consensus mechanism, an important property is that the consensus state changes have majority of value-holder approval.
If a state change destroys more value than it creates, the majority will reject it.
So each of the 2 consensus mechanisms are ultimately measuring the opinion of the same distribution of users.

Either 1 consensus mechanism is better for asking the opinion of the distribution, or the other is better. There is no reason to have both.


The DAO, a controversial dapp that was built onto Ethereum was a type of oracle. It made a decision that the validators disagreed with. So the validators forked the protocol to stop the DAO.
Having 2 consensus mechanisms at once is bad, because they can disagree.