by "layering consensus mechanism" I mean like how Augur is built on top of Ethereum. Ethereum consensus has a turing complete language, and Augur consensus is implemented in that language as a contract on Ethereum.

Layering consensus mechanisms does not increase security, but it does incease cost.
The weaknesses in each mechanism are additive, and the costs are additive. The security level for the combination is worse than either alone.

Consensus mechanisms are terribly complicated protocols, writing them inside of each other is difficult to do, and difficult to maintain.

Pink Fairy already have majority value-holder consensus, so we don't also need bonded consensus.

[This is similar to how making the oracle consensus be a seperate consensus mechanism from the blockchain consensus would be a mistake](oracle_theory.md)
