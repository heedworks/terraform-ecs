platform := $(shell uname)
pydeps := pyyaml pylint boto3 autopep8 Figlet termcolor 

ifeq (${platform},Darwin)
install-third-party-tools:
	brew install terraform python3
else
install-third-party-tools:
	@echo "${platform} is a platform we have no presets for, you'll have to install the third party dependencies manually (terraform, python3)"
endif

ifeq (${platform},Darwin)
install-python-dependencies:
	pip3 install --upgrade ${pydeps}
else
install-python-dependencies:
	pip3 install --upgrade ${pydeps}
endif

list-python-dependencies:
	@echo "This project has the following Python dependencies:\n"
	@echo "    ${pydeps}\n"

terraform-init:
	@test "${ACCOUNT}" || (echo '$$ACCOUNT is required' && exit 1)

	cd ./accounts/$(ACCOUNT) && \
	terraform init

terraform-plan:
	@test "${ACCOUNT}" || (echo '$$ACCOUNT is required' && exit 1)

	cd ./accounts/$(ACCOUNT) && \
	terraform plan -input=false -var-file=terraform.tfvars --out terraform.tfplan

	@echo "To execute this plan, run the following command:\n"
	@echo "    make terraform-apply ACCOUNT=$(ACCOUNT)\n"

terraform-apply:
	@test "${ACCOUNT}" || (echo '$$ACCOUNT is required' && exit 1)

	cd ./accounts/$(ACCOUNT) && \
	terraform apply terraform.tfplan

terraform-show:
	@test "${ACCOUNT}" || (echo '$$ACCOUNT is required' && exit 1)

	cd ./accounts/$(ACCOUNT) && \
	terraform show

copy-key:
	@test "${IP}" || (echo 'bastion $$IP required' && exit 1)
	@test "${ACCOUNT}" || (echo '$$ACCOUNT is required' && exit 1)
	
	@scp -i ssh-keys/se-$(ACCOUNT)-account.key \
		ssh-keys/se-$(ACCOUNT)-account.key \
		ubuntu@${IP}:/home/ubuntu/.ssh/ecs-key.pem
	
	@ssh -i ssh-keys/se-$(ACCOUNT)-account.key \
		ubuntu@${IP} \
		chmod 400 /home/ubuntu/.ssh/ecs-key.pem

.PHONY: install-third-party-tools install-python-dependencies list-python-dependencies terraform-plan terraform-apply terraform-init terraform-show
