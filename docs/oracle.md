Users can ask a question and put up a safety deposit.

For each oracle, there are 5 ways users can vote:
1) yes
2) no
3) bad question
4) needs more time
5) no participation

The portion of voters who selected 1 divided by all the voters from these blocks is (1).

There are 4 choices we can make:
1) return yes
2) return no
3) throw out the question
4) give it more time

First off, look at how many people said it was a bad question (3).
If it is above threshold A, then throw out the question.

Next look (4)/((1)+(2)), if it is above a threshold B , then give it more time.

Next look at (1)+(2)+(3), if it is below a threshold C, then give it more time.

Finally look at ((1)-(2)) / ((1)+(2)), if it is above D, return yes, if it is below -D return no, and if it is in between, then give it more time.