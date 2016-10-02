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
- oracle_publish
- oracle_reward


# new_account

*give: new hash of pubkey, initial money

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
Depending on how recently you voted, you can be punished or rewarded. The system is incentivized to get everyone to vote frequently.
If we assume that more than 1/2 of the users want the system to stay unforked, then waiting until more than 1/2 of them vote is finality.
The frequency that users vote determines finality.

#vote

Everyone makes this tx very frequently.
* These txs are not included in the block, only the root hash is.
* The random number generator is used to select several accounts randomly.
* The finality_sign tx made by those accounts is written on the block.
* This tx controls publishing the current time.
* This tx controls many constants that define the current blockchain behavior.
* This is to stop a certain class of forks.
* Users only download part of the most recent finality_sign set of signatures. They only download enough randomly to be about 99% sure that it is the right block.
* They can choose to change any "reveal_decision" tx, and destroy a deposit from the person who made it.

# add_randomness  

only one person can do this per block.
It rotates randomly.
You know that your turn is coming up X blocks ahead of time.
Every time you reveal randomness it needs to be the inverse hash of the previous randomness you revealed.
Before you can reveal randomness, you need to publish the final hash of the chain and wait for finality.
You can easily prove that you waited finality by refering to your account at an old height.
