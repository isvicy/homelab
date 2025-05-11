.POSIX:

export KUBECONFIG = $(shell pwd)/../kubespray/inventory/unraid/artifacts/admin.conf

.PHONY: bootstrap
bootstrap:
	ansible-playbook \
		bootstrap.yml
