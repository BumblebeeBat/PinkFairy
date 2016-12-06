For ubuntu, I needed to install dependencies:

```
sudo apt-get install erlang libncurses5-dev libssl-dev unixodbc-dev g++ git erlang-base-hipe
```
Next, download Pink Fairy

git clone https://github.com/BumblebeeBat/PinkFairy.git

now you can go into the directory, and download the dependencies.

```
cd PinkFairy
sh install.sh
```
Start the node with this script:

```
sh start.sh
```
