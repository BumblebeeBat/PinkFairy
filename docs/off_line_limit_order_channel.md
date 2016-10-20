You make a channel with an account that manages a market.
Everyone who wants to trade is making channels with this same account.
Your current channel state looks like this:
```
You have: $1000, partner has: $500, contract has: 0, contract code: "".
```

You want to buy shares of a synthetic asset linked to the value of gold.
You only want to make this purchase if the gold costs less than $1280 per ounce.
So, you make a channel like this and both sign it.

```
You have: 0, partner has: $2,
contract has: $1498, contract code: "
    The channel can only be closed 
    at this state if the market manager 
    has signed over a current trading 
    price, and it is =< $1280 per ounce.
    If you can show that the market 
    manager signed over 2 final prices, 
    then you can take all the money 
    from the channel, and the market 
    manager gets nothing. 
    % this is similar to slasher-transaction 
    % in some bonded proof of stake protocols.

    Y = final price of gold per ounce that the market manager chose.
    X = 998 / Y,%this is the number of ounces of gold you own.
    Z = oracle("price of gold ounce"),
    B = X * Z,
    The first B dollars go to you, any remaining money goest to your partner.
"
```

The goal here is to make sure that the market manager can only choose a price once. So that he sells the shares for the same price he is buying them for.
Making sure that the market manager can't select 2 different prices is similar to making sure that the validators don't sign on contradictory forks.

Between rounds of making trades, the market manager needs to wait a long time.
He needs to close all the channels that can be closed at that price.
If they are offline, he has to close the channel the slow way.
Once the channels are closed, then he can select the next price for the next set of trades to close.


Another feature we want is for the market maker to have _multiple_ batches of trades, and to not get punished for releasing multiple prices.
We want our trade to get included in the earliest batch possible. So if you can prove that the validator made an earlier batch that would have worked for you, you should be able to slash him.
