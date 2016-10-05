###Rules for blocks to be considered valid:

1. All tx must be valid. 
2. Must reference hash of previous block.
3. The person who creates the block signs it.
4. Block creator pays a fee: `base_fee*2^(block_height-prev_block_height)`
5. Balances must stay positive.
6. Convince at least 37 of the possible validators to sign in the folowing block, there are 54 possible on average.
7. Amount of money bonded in each block can only change by a small percentage from the average of the last few blocks.
8. Amount of money bonded must be at least 2 times bigger than the amount spent in the block.
9. enough POW must be provided.
10. >2/3rds of the validating power must sign over the block before finality

### Rules for tx:
Every address has a nonce that updates on each tx. To be valid, the tx must include the current nonce. Each tx must reference the hash of a recent block. Block-creator, tx-creator, and signers benefit if the tx references a more recent block.

### tx types:
- new_account
- delete_account
- repo
- spend
- vote
- start_randomness
- add_randomness
- to_channel
- channel_solo_stop
- channel_timeout
- channel_slash
- channel_team_close
- channel_repo
- oracle_commit
- oracle_died
- oracle_publish
- oracle_reward


# Which tx types should be hashlockable?
It is possible to connect pairs of hashlockable transactions together, so either they both happen, or else neither happens.
It is also possible to connect a hashlock from a channel to a hashlocked transaction. So that updating the channel and including the transaction on-chain either both happen, or neither.
The hashes are all sha256, so it should be compatible for inter-ledger transactions.
By hashlocking oracle_commit transactions to channel contracts, its possib


- new_account
- delete_account
- spend
- oracle_commit


# new_account

*give: new hash of pubkey(s), initial money

The account can be a N of M multisig. The datastructure of pubkeys gets hashed into an address of the same length either way.
{weightedAddresses, minimum_weight}
weightedAddresses = [{address1, weight1} ...]
So a 1 of 1 is like: {[{address, 1}], 1}

The initial money needs to be above some minimum.
Your account id isn't known until the transaction gets included in a block.
Creating the account costs a fee. This is like a safety deposit to encourage the account to eventually get deleted.

# delete_account

It is made by the account being deleted.
Sends the remaining money to some other account.

# repo

If an account ran out of money, then you can use this tx to delete that account from the database and reclaim the space for new accounts.
It gives a reward that is smaller than the cost of creating an account.

# spend

This sends some of your money to another account.

# vote

Anyone can make this tx at any time.
This tx does not get included on the block, it is in a merkle trie and only the root hash is written on the block.
When deciding which fork to download, users do random samples of the votes.
They prefer the fork that was signed more recently.
Every time you make a vote tx, it replaces the previous vote you had made.
On every block a random number is used to select a handful of vote txs to be written onto the blockchain.
The vote txs that are on the block are used for:
* publishing the current time
* updating the constants that define the consensus protocol.
* changing any decisions made by the oracle mechanism.
Depending on how recently you voted, you can be punished or rewarded. The system is incentivized to get everyone to vote frequently.
If we assume that more than 1/2 of the users want the system to stay unforked, then waiting until more than 1/2 of them vote is finality.
The frequency that users vote determines finality.

# start_randomness

This is how you can start participating in the random number generator.
You would want to participate in order to receive rewards from the random number generator.
You provide a hash to start the chain. Every number in the chain is the inverse hash of the previously revealed number.

# add_randomness  

only one person can do this per block.
It rotates randomly.
You know that your turn is coming up X blocks ahead of time.
Every time you reveal randomness it needs to be the inverse hash of the previous randomness you revealed.
Before you can reveal randomness, you need to publish the final hash of the chain and wait for finality.
You can easily prove that you waited finality by refering to your account at an old height.
This gives you a reward.

# to_channel

Can increase the amount of money in the channel.
Can change the default distribution of money.
Can increase the channel nonce.
Can change how much gas there is for running contracts.

# channel_solo_stop

If your partner disappears, this is how you can begin the process of closing the channel without their help.
You should only use the highest-nonced state you have, otherwise your partner can punish you for cheating.
This transaction involves running turing complete code with gas.

# channel_slash

If your partner tries closing the channel at the wrong point in history, this is how you provide evidence to punish them for cheating.
This transaction involves running turing complete code with gas.

# channel_timeout

If you did not get slashed, and you waited at least delay since channel_solo_stop, then this is how you close the channel and get your money out.

# channel_team_close

This closes the channel.
This tx says a final balance for each account.

# channel_repo

Allows you to close the channel in one step. You get all the money from the channel.
You can only make this tx if your partner's account is very low on funds, and will soon get repo-ed.

# oracle_commit

This is the first step of the oracle mechanism.
The oracle is a user.
This transaction locks up a big safety deposit from the oracle.
The oracle is making a commitment to judge over something by a certain date.
For example, he could promise to tell us who won the presidential election within a week of the date when we expect to find out.
When making this tx, there is space for a bet-number that can be set to any bytes the author wants. (maybe limit it to 1 byte).

It is possible to make bets about whether anyone will commit to providing judgement. These bets happen in the state-channels.
These bets are about what the bet-number will be used for things that can be bet on.
That way we can make dominant assurance contracts in the channels, and use the DAC to provide funding for the oracle.
You can read about them on page 14 of this paper from the Truthcoin project: https://github.com/psztorc/Truthcoin/raw/master/docs/3_PM_Applications.pdf

# oracle_died

If the oracle fails to publish on time, then the safety deposit is destroyed and the voters can determine the outcome of the bet.

# oracle_publish

This is the second step of the oracle mechanism. The event has occured in meat space. Someone won the presidential election, so now the oracle uses this tx to publish the result on-chain.

# oracle_reward

If the voters haven't changed the oracle's decision about the meatspace event, then the oracle can use this tx to get his safety deposit back.