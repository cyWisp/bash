function kill_target_port () {
	lsof -i TCP:$1 | grep LISTEN | awk '{print $2}' | xargs kill -9
}

kill_target_port $1
