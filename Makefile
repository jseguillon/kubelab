.PHONY: install plan apply deploy destroy all

# Set the path to your Terraform configuration directory
TF_DIR = terraform

# Set the path to your Ansible playbook
ANSIBLE_PLAYBOOK = ansible/playbook.yml
TF_VERSION = 1.6.5
TF_DEST := $(shell realpath ./.bin)
ANSIBLE_VENV := .ansible-venv

install:
	# Install Terraform
	@if ! [ -f "${TF_DEST}/terraform" ]; then \
		echo "Installing Terraform v$(TF_VERSION)..."; \
		curl -fsSL https://releases.hashicorp.com/terraform/$(TF_VERSION)/terraform_$(TF_VERSION)_linux_amd64.zip -o /tmp/terraform.zip; \
		unzip /tmp/terraform.zip -d ${TF_DEST}; \
		rm -f /tmp/terraform.zip; \
	fi
	@${TF_DEST}/terraform --version

	# Install Ansible with a virtual environment if not already installed
	@if ! [ -d "$(ANSIBLE_VENV)" ]; then \
		echo "Installing Ansible..."; \
		python3 -m venv $(ANSIBLE_VENV); \
		. $(ANSIBLE_VENV)/bin/activate && pip install ansible; \
	fi
	@ansible --version

plan:
	@cd $(TF_DIR) && ${TF_DEST}/terraform init
	@cd $(TF_DIR) && ${TF_DEST}/terraform plan

apply:
	@cd $(TF_DIR) && ${TF_DEST}/terraform init
	@cd $(TF_DIR) && ${TF_DEST}/terraform apply

deploy:
	@. ${ANSIBLE_VENV}/bin/activate && ansible-playbook $(ANSIBLE_PLAYBOOK)

destroy:
	@cd $(TF_DIR) && ${TF_DEST}/terraform init
	@cd $(TF_DIR) && ${TF_DEST}/terraform destroy

all: install plan apply deploy destroy
