it would be cool if chalang had optional static typing, with the ability to define new types. That way we could move some checks to compile time.

channel_rent explained in channel_rent.md

The time limit until the channel can be closed should be a different number depending on who is closing the channel.


maybe the RNG should include entropy from block hashes: http://whysos3rious.com/wp-content/uploads/2016/10/Wss_RNG.pdf


The language needs to be able to verify merkle proofs.
Each block needs a merkle root of the questions that have been asked. Questions need to be variable sized, but we only store the hash of the question on-chain, so it is fixed sized.
We need a way to query accounts by address. Making a key-based merkle patricia trie is probably too much work, instead we should give it an sql database linking each user name to an account id. The sql database for names is optional, only for nodes who want the ability to query any name.

Maybe each user should store the ids-name combos for the people who he chats with or makes payments to most frequently. That way you can ask people in your friend circle and find out the id for your friend that way.