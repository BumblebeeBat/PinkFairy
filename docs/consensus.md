A timeline of how a block N is added to the consensus chain.

The branches of the blockchain are potential futures that may come to pass. The trunk is the finalized history of the chain that will never be reverted.

The first step of adding a block is to collect the transactions together into a block, and give it sufficient POW.

The POW in this mechanism is not big enough to stop double-spends. The only reason we use POW is so there wont be too many branches on the tree, and validators will be able to download all the branches and make an informed decision on which branch to follow.

Out of the set of blockes in the branches, the users can choose a hash that they think should be included into the trunk. Signing onto a hash means you also want to include all the ancestors of that block.

Once a branch has sufficient number of users signed onto it, then it is considered finalized and included in the trunk. The branch that has a higher amount of participation is the prefered history for the full nodes.

The validators don't download this entire data structure of users who signed on branches. They only download a random subset to have statistical assurance that it is valid.
For the blockchain to be secure, we want every account to sign the chain at least once every C blocks (probably once a month), and we want more than half of the money to sign the chain at least once every D blocks (probably twice a day).
Each block contains a handful of census selected randomly using the built-in random number generator. The same RNG that is used to select validators. These handful of txs are used to slightly adjust constants that define the protocol. This is also a chance to stop any oracle from publishing a lying decision.

To create entropy for the RNG, on each block one user is selected round-robin from the trie containing fork-votes. Round robin as in incrementing the key-integer from 0 to highest. To participate they must have used a start_random_tx to initialize their entropy, and enough time must have passed since the start_random_tx.
Every time they are selected as the leader, they can reveal the root-hash of the entropy that they revealed the previous time.
It is hashed into the old entropy to make the new entropy for the blockchain.

choice:
1) for a block to be in the trunk, it needs to have had > some minimum participation from coin holders.
* what if we there is no block with that much participation?
- need to hard fork.
2) whichever choice has the highest participation from coin holders is best.
* what if a majority hides their majority, and reveals late to cause a fork for people who were offline?
-we already can't defend from the majority, so it doesn't matter.



what if an attacker stops us from knowing about some of the validator signatures that can be revealed?
* we write how much money is controled by each branch on the branches of the trie. That way our random number generator can select exactly as many addresses as we need, and if some information is unavailable, we at least know that it exists.


What strategy should the validators use to choose which block to sign next?
1) minimize censorship
2) maximize coins destroyed
3) increase the number of finalized blocks regularly

attacks:
1) attacker focuses on nodes that were offline and can't measure censorship.
2) attacker creates a fork where they burn lots coins, and un-spend an even bigger transaction.
3) attacker has a large minority (like 15%) of coins, and signs on the chain early to encourage everyone to follow his favorit path. So if only 5% of other validators are online, the attackers 15% can double-spend.

So the block isn't finalized until more than 50% of validators sign on it.

This consensus mechanism reaches finality very slowly.
Once the network is fully grown, it can take days for a transaction to get finalized.
Channels are instant.

One attack we need to prepare for is the long-range attack. Everyone moves their money into new accounts, and they sell the private keys to their old accounts.
Using all these private keys, someone could make a new history that looks just as legitimate as the current one.
The solution to this has 2 parts:
1) We need to limit how much money can move around per block, so that the current distribution of money is fairly similar to the one that existed yesterday. That way, attacks like this can only cause forks that start more than a day ago.
2) We need to use weak subjectivity. You go to someone who sells stuff in exchange for the currency, and you find out which fork has more valuable currency.
The more valuable fork is the one worth following.
There needs to be a way to give a roothash to your node so that your node will only download forks that include that roothash as an acestor.
Because of (1), at most you only need to enter a roothash once per 24 hour period. 