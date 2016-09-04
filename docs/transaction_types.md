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
- create_account
- spend
- delete_account
- sign
- slasher
- reveal %we probably don't need this because add_randomness makes all the entropy we need.
  % we do need it because it gives time for a slasher to happen between the sign and reveal.
- finality_sign (only root hash is included in the block, not the txs)
- to_channel
- channel_block
- channel_timeout
- channel_slash
- channel_close
- channel_funds_limit
- repo
- commit_decision
- reveal_decision
- finalize_decision
- start_randomness
- add_randomness 

#finality_sign

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

only one person can do this per block. It rotates by round robin rules. If account 5 has the power, and you are account 20, then your turn is in about 15.
Only users who have more than 1/2 of the average amount of money can participate in the randomness.
Maybe, if you have a lot of money, you should participate more than once in a row.
Every time you reveal randomness it needs to be the inverse hash of the previous randomness you revealed.
Before you can reveal randomness, you need to publish the final hash of the chain and wait for finality.
You can easily prove that you waited finality by refering to your account at an old height.