A timeline of how a block N is added to the consensus chain.

Constants: A, B, C

For each block, about B validators are selected randomly. A block needs at least 2*B/3 signatures from validators to be in the chain.

First, validators sign over block N-1. Once there are >2/3rds signature, miners can start mining.

The miners collect the signatures along with more transactions into potential block Ns. One or more block Ns with signatures and POW are created.

Validators sign over whichever block N. If any of them have enough signatures, then miners start mining on it.


When validators sign the block they give a safety deposit to defend agains the possibility that they will double-sign.
The total amount of money in the safety deposit for each block is 3x bigger than the amount of money spent in the block.
So, if there is only 1 fork, the cost of using a double-sign to double-spend the tx will be more expensive than how much money could be saved.


Block N can be built on top of block N-X, the validators need to burn 2^X times more money than usual, and if the miners need to mine 2^X times more money than usual. If we skip a height, then all the validators selected for that height miss their turn.
If you spend D amount of money, and the amount of money burned to create a block is E, then that means you need to wait log2(D/E) blocks for your tx to be finalized.


At every block every account is allowed to sign on whichever of the chains they think is valid. This is called the census. They choose a hash deeper into history, to take less risk.
The validators don't download this entire data structure. They only download a random subset to have statistical assurance that it is valid.
For the blockchain to be secure, we want every account to sign the chain at least once every C blocks (probably once a month), and we want more than half of the money to sign the chain at least once every D blocks (probably twice a day).
Each block contains a handful of census selected randomly using the built-in random number generator. The same RNG that is used to select validators. These handful of txs are used to slightly adjust constants that define the protocol. This is also a chance to stop any oracle from publishing a lying decision.
Including more census transactions on the block decreases the cost of creating the block.

To create entropy for the RNG, on each block one user is selected round-robin from the trie containing fork-votes. Round robin as in incrementing the key-integer from 0 to highest. To participate they must have used a start_random_tx to initialize their entropy, and enough time must have passed since the start_random_tx.
Every time they are selected as the leader, they can reveal the root-hash of the entropy that they revealed the previous time.
It is hashed into the old entropy to make the new entropy for the blockchain.
