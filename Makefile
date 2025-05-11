.POSIX:
.PHONY: *
.EXPORT_ALL_VARIABLES:

KUBESPRAY_DIR = $(shell pwd)/kubespray
KUBECONFIG = $(KUBESPRAY_DIR)/inventory/unraid/artifacts/admin.conf
KUBE_CONFIG_PATH = $(KUBECONFIG)

default: metal-boot deploy-kubespray-cluster system external smoke-test post-install clean-docker

configure:
	./scripts/configure
	git status

metal:
	make -C metal

metal-boot:
	make -C metal boot

deploy-kubespray-cluster:
	cd $(KUBESPRAY_DIR) && ansible-playbook -v \
		--inventory inventory/unraid/inventory.ini \
		cluster.yml

reset-kubespray-cluster:
	cd $(KUBESPRAY_DIR) && ansible-playbook -v \
	        --inventory inventory/unraid/inventory.ini \
		reset.yml

system:
	make -C system

external:
	make -C external

smoke-test:
	make -C test filter=Smoke

post-install:
	@./scripts/hacks

# TODO maybe there's a better way to manage backup with GitOps?
backup:
	./scripts/backup --action setup --namespace=actualbudget --pvc=actualbudget-data
	./scripts/backup --action setup --namespace=jellyfin --pvc=jellyfin-data

restore:
	./scripts/backup --action restore --namespace=actualbudget --pvc=actualbudget-data
	./scripts/backup --action restore --namespace=jellyfin --pvc=jellyfin-data

test:
	make -C test

clean:
	docker compose --project-directory ./metal/roles/pxe_server/files down

docs:
	mkdocs serve

git-hooks:
	pre-commit install
