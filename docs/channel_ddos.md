A common criticism of state-channels today is an attack scenario like this:
The attacker makes it so users can't get their transactions onto the blockchain, but the attacker can.
The attacker closes the channels at incorrect histories, when the attacker controlled more money in the channel.

As Vitalik said it: "When most application on a chain rely on state-channel architectures, liveness IS safety."

The goal of this paper is to show that off-chain contracts can be made just as secure as on-chain contracts, provided we are willing to publish a small amount of data on-chain every time the channel-state is updated.

Every time the state in an off-chain contract is updated, the owners of the contract increase the channel-nonce written on the channel.
When the blockchain mediates a channel, the blockchain prefers high-nonced states to lower-nonced ones.

If the owners of the contract want a guarantee that old states wont be used, they could simply tell the blockchain about their current channel-nonce.
The blockchain will ignore any states that preceded the nonce you give it.

In practice, because of the transaction fee for writing anything on-chain, users will update their channel-nonce on-chain only when it is profitable to do so.

It is profitable to update the channel-nonce if:
abs((amount of money you had when you were richest) - (amount you had when you were poorest)) > (transaction fee to update the channel-nonce) / (probability of attack)

State channels give you the freedom to update the on-chain state only when it is helpful to do so.
State channels are not any more vulnerable to liveness attacks than on-chain contracts.