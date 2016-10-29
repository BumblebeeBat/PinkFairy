Light clients don't download the entire block, they only download the header. The header can be used to prove that it's chain is in consensus.

The header contains:
* The hash of the previous block.
* the root hash of the state.
* the current entropy in the random number generator.
* the consensus votes which are included for this block.
* the add_entropy transaction, if it was included for this block.
