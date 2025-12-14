.PHONY: fmt validate plan up lint destroy check hooks

fmt:
	terraform fmt -recursive terraform

validate:
	cd terraform/environments/lab && terraform init -backend=false && terraform validate
	cd ansible && ansible-playbook playbooks/site.yml --syntax-check -i inventory/hosts.ini.example

plan:
	scripts/provision.sh --plan

up:
	scripts/provision.sh

destroy:
	cd terraform/environments/lab && terraform destroy

check:
	scripts/check-cluster.sh

lint:
	cd ansible && ansible-lint playbooks roles
	shellcheck scripts/*.sh

hooks:
	pre-commit install
