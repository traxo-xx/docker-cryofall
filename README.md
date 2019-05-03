docker-cryofall
===============

I made this because there is currently no official Docker image for CryoFall. It's a bit hacky since I'm using `tmux` and `socat` to be able to send the correct stop command to the running server.


**Prerequisites**

This is currently for Linux systems only.
You need to have `netcat`, `socat` and `tmux` installed.

**Installation**

```
git clone git@github.com:traxo-xx/docker-cryofall.git ${HOME}/docker-cryofall
cd ${HOME}/docker-cryofall
cp cryofall_docker.config.example cryofall_docker.config
```
Modify the config file `cryofall_docker.config` if needed. Then run `./cryofall_docker.sh init`. This should have created the initial server files in `${HOME}/docker-cryofall/data`. 

For specific information regarding the server configuration, please have a look at the official CryoFall wiki: http://wiki.atomictorch.com/CryoFall/Server/Setup


**Usage**

Start the server:

```
./cryofall_docker.sh start
```

Stop the server:

```
./cryofall_docker.sh stop
```
View the the container's logs:

```
./cryofall_docker.sh logs
```