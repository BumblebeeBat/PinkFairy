The problem with delegated proof of stake is that it moves the cost of consensus into advertising costs.

Can delegation be used for convenience without making delegated proof of stake the consensus algorithm?

There would need to be a tx type for changing who you delegate to.

I see two ways to do this:

1)
Besides following the consensus, each user would have to stay aware of txs in the mempool for changing delegation.
That way, we can have the fork choice rule ignore any forks that are censoring delegation transactions.

The problem with this method is that offline nodes wont be able to know that censorship occured.


Maybe since the majority of nodes come online during each consensus period, enough users will know about the censorship to kill that fork?

This method is best if finality is a short period of time. Because users are coming online more frequently it is quicker to detect censhorship.


2)
There should be a limit for how long a delegate key lasts. That way, if an attack like this occured, it would end after this limit of blocks.
If this limit is much smaller than finality, then when the keys expire, the malicious changes can all be reverted.

This method is best if the finality is a long period of time. Because if finality is long, it means we can delegate for longer periods of time.