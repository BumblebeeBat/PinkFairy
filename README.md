Bitcoin Donations: 1GbpRPE83Vjg73KFvTVZ4EnS2qNkiLY5TT

A security vulnerability was found in Flying Fox. The goal of this project is to reuse the good parts of Flying Fox and to patch the security vulnerability.

The major difference between this and Flying Fox is that there are now 2 steps to block verification. First a random jury of users are selected for each block. 

Then a few blocks later everyone selects one of the paths to follow. The root hash of the merkle tree of everyone's signatures is written on the block. A group of the signers are selected using the random number generator, so we can get statistical assurance that the block is valid.

https://github.com/BumblebeeBat/FlyingFox

Goals of this project:

1 we should be able to delete old blocks

2 each node, including validator nodes, should only have to keep track of their own state in the database.

3 the oracle for betting should be integrated with the blockchain consensus mechanism. That way, the same distribution of people who controls the blockchain also controls the outcome of prediction markets.

Look at how the DAO made Ethereum split into 2 pieces.
This is because the outcome of where the DAO sent money wasn't being controlled by the same consensus mechanism as ethereum.
So the majority of users who controled the consensus mechanism decided to do a fork.
In order to avoid events like this, we need to make sure that the same distribution that controls the blockchain consensus should also control the outcome of prediction markets.