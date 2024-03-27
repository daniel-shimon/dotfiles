docker-ipython() {
	local local_hist_file="$(ipython locate profile default)"/history.sqlite
	local docker_hist_file="$(docker exec $1 ipython locate profile default)"/history.sqlite
	cp "$local_hist_file" "$local_hist_file".bk
	docker cp --quiet "$local_hist_file" $1:"$docker_hist_file"
	docker exec -it $1 ipython
	docker cp --quiet $1:"$docker_hist_file" "$local_hist_file"
}
