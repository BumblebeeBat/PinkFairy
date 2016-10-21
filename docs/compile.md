First, make sure you have erlang installed. Version 18 is prefered, but older versions will probably work. Here is one way to download it: http://www.erlang.org/download.html , here are erlang install instructions: http://www.erlang.org/doc/installation_guide/INSTALL.html

For ubuntu, I needed to install dependencies:

```
sudo apt-get install libncurses5-dev
sudo apt-get install libssl-dev
sudo apt-get install unixodbc-dev
sudo apt-get install g++
sudo apt-get install git
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
