use a seperate key for signing vote transactions, that way your money key can stay offline while the voting key is online.

it would be cool if chalang had optional static typing, with the ability to define new types. That way we could move some checks to compile time.

channel_rent explained in channel_rent.md

The time limit until the channel can be closed should be a different number depending on who is closing the channel.


maybe the RNG should include entropy from block hashes: http://whysos3rious.com/wp-content/uploads/2016/10/Wss_RNG.pdf


The language needs to be able to verify merkle proofs.
Each block needs a merkle root of the questions that have been asked. Questions need to be variable sized, but we only store the hash of the question on-chain, so it is fixed sized.
We need a way to query accounts by address. Making a key-based merkle patricia trie is probably too much work, instead we should give it an sql database linking each user name to an account id. The sql database for names is optional, only for nodes who want the ability to query any name.

Maybe each user should store the ids-name combos for the people who he chats with or makes payments to most frequently. That way you can ask people in your friend circle and find out the id for your friend that way.

We need a patricia trie that stores by arbitrary key. We need it for the naming system so that users can have unique names.

Maybe we should delete old stuff from the oracle trie. Once all the bets are settled, the information doesn't matter. Maybe we will give them a month to close their bets.

Maybe we should do a truthcoin-like SVD between the votes that are included in the block. Then people would vote beliefs instead of desires.

Maybe we should do an anti-pre-revelation game https://blog.ethereum.org/2015/08/28/on-anti-pre-revelation-games/
Then it would be harder for validators to collude to make the oracle go bad.
We cant use an APR game for voting, because some people consistently vote against the majority and shouldn't be punished for having a different opinion.

The fork choice rule for downloading is easy. Which fork has the most votes from most recent.
The fork choice rule for signing is a littel more complicated. It balances 2 goals.
1) sign on the fork that has the most signatures from other users
2) sign on the fork that has the least censorship

Because of tragedy of the commons, it is too affordable to bribe the users to vote wrong.
https://github.com/ethereum/wiki/wiki/Proof-of-Stake-FAQ
So, we need rather harsh limits on how fast you can move your money around.
The amount of money you have is your account balance + 1/2 the size of all your channels.
You can grow the amount of money you have as fast as you want.
At all times you must have at least 1/2 as much money as the most you had in the last finality period.
There is a vote-flag in your account. If your vote flag has been off for the last finality period, then you can completely drain your account at once.
If your vote flag is off, then you cannot vote.
If your vote transaction is selected, then we need to reward you. Otherwise the nash equilibrium would be to not vote.