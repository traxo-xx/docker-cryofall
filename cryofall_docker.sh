#!/bin/bash

hash tmux 2>/dev/null || { echo >&2 "Required command 'tmux' is not installed.  Aborting."; exit 1; }
hash socat 2>/dev/null || { echo >&2 "Required command 'socat' is not installed.  Aborting."; exit 1; }
hash nc 2>/dev/null || { echo >&2 "Required command 'netcat' is not installed.  Aborting."; exit 1; }

source ./cryofall_docker.config

if [[ "${docker_net}" != "" ]]; then
    docker_net_param="--net ${docker_net}"
fi

if [[ "${docker_ip}" != "" ]]; then
    docker_ip_param="--ip ${docker_ip}"
fi

start_server() {
    echo "Starting CryoFall Server..."
    tmux new -d -s ${tmux_session} "socat EXEC:\"docker run -it ${docker_net_param} ${docker_ip_param} -p ${docker_port}\:6000/udp -v ${data_volume}\:/CryoFall/Data --name ${docker_name} ${docker_repo}\:${docker_tag}\",pty TCP-LISTEN:${command_port},bind=${command_ip},fork"
    sleep 5
    docker ps | grep "${docker_name}" > /dev/null 2>&1 && echo "Server should be up and running shortly." || echo "Error: Server couldn't be started."
}

stop_server() {
    echo "stop 0" | nc -w2 ${command_ip} ${command_port} > /dev/null 2>&1 && sleep 5 && tmux kill-session -t ${tmux_session} && echo "Server has been stopped." || echo "Error: Server couldn't be stopped."
}

server_logs() {
    docker ps | grep "${docker_name}" > /dev/null 2>&1 && docker logs ${docker_name} || echo "Error: Server doesn't seem to be running"
}

case "$1" in 
    start)   start_server ;;
    stop)    stop_server ;;
    restart) stop_server; start_server ;;
    logs)    server_logs ;;
    *) echo "usage: $0 start|stop|restart|logs" >&2
       exit 1
       ;;
esac