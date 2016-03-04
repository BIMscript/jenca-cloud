#!/bin/bash -e

export K8S_VERSION=${K8S_VERSION:="1.1.1"}

usage() {
cat <<EOF
Usage:
k8s.sh etcd
k8s.sh proxy
k8s.sh hyperkube
k8s.sh start
k8s.sh stop
k8s.sh restart
k8s.sh help
EOF
	exit 1
}

# stop any container that the output of docker ps matches against the
# given grep pattern
grepstop-container() {
	local pattern=$1
	docker rm -f $(docker ps -a | grep $pattern | awk '{print $1}')
}

# start the etcd docker container
cmd-etcd() {
	docker run -d \
	  --name etcd \
	  --net host \
	  kubernetes/etcd:2.0.5.1 \
	  /usr/local/bin/etcd \
	  	--addr=127.0.0.1:4001 \
	  	--bind-addr=0.0.0.0:4001 \
	  	--data-dir=/var/etcd/data
}

# start the various kubernetes containers via the kyperkube
cmd-hyperkube() {
	docker run -d \
		--net host \
		-v /var/run/docker.sock:/var/run/docker.sock \
		gcr.io/google_containers/hyperkube:v${K8S_VERSION} \
		/hyperkube kubelet \
			--api_servers=http://localhost:8080 \
			--v=2 \
			--address=0.0.0.0 \
			--enable_server \
			--hostname_override=127.0.0.1 \
			--config=/etc/kubernetes/manifests
}

# start the kubernetes proxy (we are running the kubelet on this node)
cmd-proxy() {
	docker run -d \
		--net host \
		--privileged \
		gcr.io/google_containers/hyperkube:v${K8S_VERSION} \
		/hyperkube proxy \
			--master=http://127.0.0.1:8080 \
			--v=2
}

# wrapper to start the whole stack
cmd-start() {
	cmd-etcd
	cmd-hyperkube
	cmd-proxy
}

# logic to remove only the jenca/kubernetes containers
cmd-stop() {
	grepstop-container k8s_scheduler || true
	grepstop-container k8s_apiserver || true
	grepstop-container k8s_controller-manager || true
	grepstop-container k8s_controller-manager || true
	grepstop-container k8s_POD || true
	grepstop-container proxy || true
	grepstop-container kubelet || true
	grepstop-container etcd	|| true
}

cmd-restart() {
	cmd-stop
	cmd-start
}

main() {
	case "$1" in
	etcd)					        shift; cmd-etcd; $@;;
	hyperkube)					  shift; cmd-hyperkube; $@;;
	proxy)					      shift; cmd-proxy; $@;;
	start)					      shift; cmd-start; $@;;
	stop)					        shift; cmd-stop; $@;;
	restart)					    shift; cmd-restart; $@;;
	*)                    usage $@;;
	esac
}

main "$@"