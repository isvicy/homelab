.POSIX:

env ?= prod
export KUBECONFIG = $(shell pwd)/kubeconfig.yaml

default: boot cluster

~/.ssh/id_ed25519:
	ssh-keygen -t ed25519 -P '' -f "$@"

boot: ~/.ssh/id_ed25519
	ansible-playbook \
		--inventory inventories/${env}.yml \
		boot.yml

cluster:
	ansible-playbook -vvvv \
		--inventory inventories/${env}.yml \
		cluster.yml

console:
	ansible-console -vvvv \
		--inventory inventories/${env}.yml
