These are the variables that get updated at each block. The owners of money can vote to change them.

* Amount of gas per block.
* number of transactions per block.
* number of bytes per block.
* rent for an account.
* rent for a channel.
* number of voters per block.
* reward for doing POW on a block.
* amount of POW per block.
* reward for participating in RNG
* oracle safety deposit
* how many oracles can exist at once (One trie's leaf-size is determined by this number)
* how much time does the consensus mechanism have to stop a lying oracle decision.
* minimum transaction fee for each type of transaction.
* how much money needs to be destroyed as proof of burn when a block is made
* how do we calculate the current time (may be 2 or more variables?) (we need it for the oracle)
* reward for voting, which supports consensus.
* punishment for failing to vote for too long. (probably multiple variables.)