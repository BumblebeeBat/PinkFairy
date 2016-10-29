distributed coin flip.
Each user commits to a single bit that is salted.
If either user refuses to reveal, then they lose.
The winner is determined by the XOR of the bits.



Assuming Casino and Gambler have a channel, the messages would go like this:

1) Gambler chooses a random bit, salts it, and sends the hash of it to Casino with a request to gamble.
2) Casino chooses a random bit, salts it, and uses the hash of it with the hash from Gamble to make the contract. Casino signs up for the contract and sends a copy back to Gambler.
3) Gambler signs the contract. Now the bet is live.
4) Gambler reveals the secret to Casino
5) Casino calculates the result, and sends it's secret to Gambler with the new channel state. The new channel state doesn't include the bet, the money went to the winner.
6) Gambler calculates the result, and if they agree, then Gambler signs the new channel state.