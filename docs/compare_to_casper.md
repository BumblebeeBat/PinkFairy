All wasteful consnesus mechanisms ar built off these assumtions:

*Finality needs to be fast.

*The majority of money will be off-line during most finality periods.

Since the majority is offline, some minority must guide consensus. To make it trustless, the minority needs to destroy a lot of value to do this.

Pink Fairy does its computation off-chain in the channels. So fast finality is not important.
Since fast finality is not important, we don't need to give control to any minority, and we don't need to destroy value.


http://vitalik.ca/files/mauve_paper3.html

We desire these goals:

1) Consensus should be primarily secured without POW or bonds or wealth destruction. POW should be used to avoid sybil attacks that fill the ram. POW should be used to distribute new coins.

2) Economic finality - after a finite period of time, the history should become unalterable.
Even if the number of users grows, there should never be a fork that lasts longer than the finality period.

3) Scalability - it should be possible to run the blockchain even when each user only keeps track of their own state and ignores everyone else.
Although we will need at least one full node so that new users can join the system.

4) State channels - a state channel system should make it easy to make custom turing complete contracts.

5) Oracle - The final security measure of the oracle is that everyone with coins can vote to change the outcome of an oracle.
The oracle loses a big savety deposit if the majority decides that he lied.

6) Governance - The protocol is defined by a bunch of constants that determine everything from how much POW to put onto the blocks, to how much it costs to make an oracle.
All these constants are slightly updated at every block.
All the users vote to update these constants.


