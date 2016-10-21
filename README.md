
This is a blockchain. It is a type of internet money optimized for betting.

Bitcoin Donations: 1GbpRPE83Vjg73KFvTVZ4EnS2qNkiLY5TT

Thank you to Augur and other private donors for giving the funding to make this project a possibility: https://www.augur.net/


Goals of this project:

1 small finite memory requirement. Old blocks are deleted.

2 each node, including validator nodes, should only have to keep track of their own state in the database.

3 the oracle for betting should be integrated with the blockchain consensus mechanism. That way, the same distribution of people who controls the blockchain also controls the outcome of prediction markets.

4 state channels to allow trustless turing complete contracts off-chain.

5 A marketplace with batch based trading at a single price should be built in the channels.

6 The consensus mechanism should not be secured by any costly mechanism like POW or bonds.

The decision to connect the oracle consensus to the blockchain consensus is controvertial, let me try to justify:

Look at how the DAO made Ethereum split into 2 pieces.
This is because the outcome of where the DAO sent money wasn't being controlled by the same consensus mechanism as ethereum.
So the majority of users who controled the consensus mechanism decided to do a fork.
The DAO was a fancy kind of oracle which came to decisions based on the input of it's users.
In order to avoid events like this, we need to make sure that the same distribution that controls the blockchain consensus should also control the oracle's decisions.

[installation for ubuntu](docs/compile.md)

[documentation](docs/README.md)