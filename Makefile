ARM_TEMPLATE_TAG=1.1.8
RG_TAGS={"Product" : "Get into teaching website"}
REGION=UK South
SERVICE_NAME=get-into-teaching-app
SERVICE_SHORT=git
DOCKER_REPOSITORY=ghcr.io/dfe-digital/get-into-teaching-frontend

ifndef VERBOSE
.SILENT:
endif

help:
	echo "Secrets:"
	echo "  This makefile gives the user the ability to safely display and edit azure secrets which are used by this project. "
	echo ""
	echo "Commands:"
	echo "  edit-app-secrets  - Edit Application specific Secrets."
	echo "  print-app-secrets - Display Application specific Secrets."
	echo ""
	echo "Parameters:"
	echo "All commands take the parameter development|review|test|production"
	echo ""
	echo "Examples:"
	echo ""
	echo "To edit the Application secrets for Development"
	echo "        make  development edit-app-secrets"
	echo ""

APPLICATION_SECRETS=CONTENT-KEYS
PAGESPEED_SECRETS=PAGE-SPEED-KEYS
INFRA_SECRETS=INFRA-KEYS
DOCKER_IMAGE=get-into-teaching-app

.PHONY: local
local:
	$(eval export KEY_VAULT=s189t01-git-local-app-kv)
	$(eval export AZURE_SUBSCRIPTION=s189-teacher-services-cloud-test)

.PHONY: review
review: test-cluster
	$(if $(PR_NUMBER), , $(error Missing environment variable "PR_NUMBER", Please specify a pr number for your review app))
	$(eval include global_config/review.sh)
	$(eval export DEPLOY_ENV=review)
	$(eval export TF_VAR_pr_number=-${PR_NUMBER})

.PHONY: development
development: test-cluster
	$(eval include global_config/development.sh)

.PHONY: test
test: test-cluster
	$(eval include global_config/test.sh)

.PHONY: production
production: production-cluster
	$(eval include global_config/production.sh)

.PHONY: beta
beta: production-cluster
	$(eval include global_config/beta.sh)

clean:
	[ ! -f fetch_config.rb ]  \
	    rm -f fetch_config.rb \
	    || true

install-fetch-config:
	[ ! -f fetch_config.rb ]  \
	    && echo "Installing fetch_config.rb" \
	    && curl -s https://raw.githubusercontent.com/DFE-Digital/bat-platform-building-blocks/master/scripts/fetch_config/fetch_config.rb -o fetch_config.rb \
	    && chmod +x fetch_config.rb \
	    || true

setup-local-env: install-fetch-config set-azure-account
	./fetch_config.rb -s yaml-file:.env.development.yml -s azure-key-vault-secret:s189t01-git-local-app-kv/${APPLICATION_SECRETS} -f shell-env-var > .env.development

docker:
	docker build . -t ${DOCKER_IMAGE}

specs:
	docker run -t --rm -e RAILS_ENV=test ${DOCKER_IMAGE} rspec spec/features/funding_widget_spec.rb

.PHONY: ci
ci:
	$(eval AUTO_APPROVE=-auto-approve)

composed-variables:
	$(eval RESOURCE_GROUP_NAME=${AZURE_RESOURCE_PREFIX}-${SERVICE_SHORT}-${CONFIG_SHORT}-rg)
	$(eval KEYVAULT_NAMES='("${AZURE_RESOURCE_PREFIX}-${SERVICE_SHORT}-${CONFIG_SHORT}-app-kv", "${AZURE_RESOURCE_PREFIX}-${SERVICE_SHORT}-${CONFIG_SHORT}-inf-kv")')
	$(eval STORAGE_ACCOUNT_NAME=${AZURE_RESOURCE_PREFIX}${SERVICE_SHORT}${CONFIG_SHORT}tfsa)
	$(eval LOG_ANALYTICS_WORKSPACE_NAME=${AZURE_RESOURCE_PREFIX}-${SERVICE_SHORT}-${CONFIG_SHORT}-log)

.PHONY: vendor-modules
vendor-modules:
	rm -rf terraform/aks/vendor/modules/aks
	git -c advice.detachedHead=false clone --depth=1 --single-branch --branch ${TERRAFORM_MODULES_TAG} https://github.com/DFE-Digital/terraform-modules.git terraform/aks/vendor/modules/aks

bin/konduit.sh:
	curl -s https://raw.githubusercontent.com/DFE-Digital/teacher-services-cloud/main/scripts/konduit.sh -o bin/konduit.sh \
		&& chmod +x bin/konduit.sh

terraform-init: composed-variables vendor-modules set-azure-account
	$(if ${DOCKER_IMAGE_TAG}, , $(eval DOCKER_IMAGE_TAG=master))
	$(if $(PR_NUMBER), $(eval KEY_PREFIX=$(PR_NUMBER)), $(eval KEY_PREFIX=$(ENVIRONMENT)))

	terraform -chdir=terraform/aks init -upgrade -reconfigure \
		-backend-config=resource_group_name=${RESOURCE_GROUP_NAME} \
		-backend-config=storage_account_name=${STORAGE_ACCOUNT_NAME} \
		-backend-config=key=${KEY_PREFIX}.tfstate

	$(eval export TF_VAR_azure_resource_prefix=${AZURE_RESOURCE_PREFIX})
	$(eval export TF_VAR_config_short=${CONFIG_SHORT})
	$(eval export TF_VAR_service_name=${SERVICE_NAME})
	$(eval export TF_VAR_service_short=${SERVICE_SHORT})
	$(eval export TF_VAR_docker_image=${DOCKER_REPOSITORY}:${DOCKER_IMAGE_TAG})

terraform-plan: terraform-init
	terraform -chdir=terraform/aks plan -var-file "config/${CONFIG}.tfvars.json"

terraform-apply: terraform-init
	terraform -chdir=terraform/aks apply -var-file "config/${CONFIG}.tfvars.json" ${AUTO_APPROVE}

terraform-destroy: terraform-init
	terraform -chdir=terraform/aks destroy -var-file "config/${CONFIG}.tfvars.json" ${AUTO_APPROVE}

domains:
	$(eval include global_config/domains.sh)

domains-composed-variables:
	$(eval RESOURCE_GROUP_NAME=${AZURE_RESOURCE_PREFIX}-${SERVICE_SHORT}-dom-rg)
	$(eval KEYVAULT_NAMES=["${AZURE_RESOURCE_PREFIX}-${SERVICE_SHORT}-dom-kv"])
	$(eval STORAGE_ACCOUNT_NAME=${AZURE_RESOURCE_PREFIX}${SERVICE_SHORT}domainstf)

set-azure-account:
	[ "${SKIP_AZURE_LOGIN}" != "true" ] && az account set -s ${AZURE_SUBSCRIPTION} || true

set-what-if:
	$(eval WHAT_IF=--what-if)

arm-deployment: set-azure-account
	$(if ${DISABLE_KEYVAULTS},, $(eval KV_ARG=keyVaultNames=${KEYVAULT_NAMES}))
	$(if ${ENABLE_KV_DIAGNOSTICS}, $(eval KV_DIAG_ARG=enableDiagnostics=${ENABLE_KV_DIAGNOSTICS} logAnalyticsWorkspaceName=${LOG_ANALYTICS_WORKSPACE_NAME}),)

	az deployment sub create --name "resourcedeploy-tsc-$(shell date +%Y%m%d%H%M%S)" \
		-l "${REGION}" --template-uri "https://raw.githubusercontent.com/DFE-Digital/tra-shared-services/${ARM_TEMPLATE_TAG}/azure/resourcedeploy.json" \
		--parameters "resourceGroupName=${RESOURCE_GROUP_NAME}" 'tags=${RG_TAGS}' \
			"tfStorageAccountName=${STORAGE_ACCOUNT_NAME}" "tfStorageContainerName=terraform-state" \
			${KV_ARG} \
			${KV_DIAG_ARG} \
			"enableKVPurgeProtection=${KV_PURGE_PROTECTION}" \
			${WHAT_IF}

deploy-arm-resources: composed-variables arm-deployment

validate-arm-resources: composed-variables set-what-if arm-deployment

deploy-domain-arm-resources: domains domains-composed-variables arm-deployment ## Deploy initial Azure resources (resource group, tfstate storage and key vault) will be deployed. Usage: make deploy-domain-arm-resources

validate-domain-arm-resources: set-what-if domains domains-composed-variables arm-deployment ## Validate what Azure resources will be deployed. Usage: make validate-domain-arm-resources

.PHONY: vendor-domain-infra-modules
vendor-domain-infra-modules:
	rm -rf terraform/domains/infrastructure/vendor/modules/domains
	TERRAFORM_MODULES_TAG=stable
	git -c advice.detachedHead=false clone --depth=1 --single-branch --branch ${TERRAFORM_MODULES_TAG} https://github.com/DFE-Digital/terraform-modules.git terraform/domains/infrastructure/vendor/modules/domains

domains-infra-init: domains-composed-variables vendor-domain-infra-modules set-azure-account
	terraform -chdir=terraform/domains/infrastructure init -reconfigure -upgrade \
		-backend-config=resource_group_name=${RESOURCE_GROUP_NAME} \
		-backend-config=storage_account_name=${STORAGE_ACCOUNT_NAME} \
		-backend-config=key=domains_infrastructure.tfstate

domains-infra-plan: domains domains-infra-init ## Terraform plan for DNS infrastructure (zone and front door. Usage: make domains-infra-plan
	terraform -chdir=terraform/domains/infrastructure plan -var-file config/zones.tfvars.json

domains-infra-apply: domains domains-infra-init ## Terraform apply for DNS infrastructure (zone and front door). Usage: make domains-infra-apply
	terraform -chdir=terraform/domains/infrastructure apply -var-file config/zones.tfvars.json ${AUTO_APPROVE}

.PHONY: vendor-domain-modules
vendor-domain-modules:
	rm -rf terraform/domains/environment_domains/vendor/modules/domains
	git -c advice.detachedHead=false clone --depth=1 --single-branch --branch ${TERRAFORM_MODULES_TAG} https://github.com/DFE-Digital/terraform-modules.git terraform/domains/environment_domains/vendor/modules/domains

domains-init: domains-composed-variables vendor-domain-modules set-azure-account
	terraform -chdir=terraform/domains/environment_domains init -upgrade -reconfigure \
		-backend-config=resource_group_name=${RESOURCE_GROUP_NAME} \
		-backend-config=storage_account_name=${STORAGE_ACCOUNT_NAME} \
		-backend-config=key=${ENVIRONMENT}.tfstate

domains-plan: domains domains-init ## Terraform plan for DNS environment domains. Usage: make development domains-plan
	terraform -chdir=terraform/domains/environment_domains plan -var-file config/${ENVIRONMENT}.tfvars.json

domains-apply: domains domains-init ## Terraform apply for DNS environment domains. Usage: make development domains-apply
	terraform -chdir=terraform/domains/environment_domains apply -var-file config/${ENVIRONMENT}.tfvars.json ${AUTO_APPROVE}

test-cluster:
	$(eval CLUSTER_RESOURCE_GROUP_NAME=s189t01-tsc-ts-rg)
	$(eval CLUSTER_NAME=s189t01-tsc-test-aks)

production-cluster:
	$(eval CLUSTER_RESOURCE_GROUP_NAME=s189p01-tsc-pd-rg)
	$(eval CLUSTER_NAME=s189p01-tsc-production-aks)

get-cluster-credentials: set-azure-account
	az aks get-credentials --overwrite-existing -g ${CLUSTER_RESOURCE_GROUP_NAME} -n ${CLUSTER_NAME}
	kubelogin convert-kubeconfig -l $(if ${GITHUB_ACTIONS},spn,azurecli)

edit-local-secrets-aks: install-fetch-config set-azure-account
	./fetch_config.rb -s azure-key-vault-secret:s189t01-git-local-app-kv/${APPLICATION_SECRETS} -e -d azure-key-vault-secret:s189t01-git-local-app-kv/${APPLICATION_SECRETS} -f yaml -c

print-local-secrets-aks: install-fetch-config set-azure-account
	./fetch_config.rb -s azure-key-vault-secret:s189t01-git-local-app-kv/${APPLICATION_SECRETS}  -f yaml

action-group-resources: set-azure-account # make env action-group-resources ACTION_GROUP_EMAIL=notificationemail@domain.com . Must be run before setting enable_monitoring=true for each subscription
	$(if $(ACTION_GROUP_EMAIL), , $(error Please specify a notification email for the action group))
	echo ${AZURE_RESOURCE_PREFIX}-${SERVICE_SHORT}-mn-rg
	az group create -l uksouth -g ${AZURE_RESOURCE_PREFIX}-${SERVICE_SHORT}-mn-rg --tags "Product=Get into teaching website" "Environment=Test" "Service Offering=Teacher services cloud"
	az monitor action-group create -n ${AZURE_RESOURCE_PREFIX}-get-into-teaching-app -g ${AZURE_RESOURCE_PREFIX}-${SERVICE_SHORT}-mn-rg --short-name ${AZURE_RESOURCE_PREFIX}-git --action email ${AZURE_RESOURCE_PREFIX}-${SERVICE_SHORT}-email ${ACTION_GROUP_EMAIL}

maintenance-image-push:
	$(if ${GITHUB_TOKEN},, $(error Provide a valid Github token with write:packages permissions as GITHUB_TOKEN variable))
	$(if ${MAINTENANCE_IMAGE_TAG},, $(eval export MAINTENANCE_IMAGE_TAG=$(shell date +%s)))
	docker build -t ghcr.io/dfe-digital/get-into-teaching-app-maintenance:${MAINTENANCE_IMAGE_TAG} maintenance_page
	echo ${GITHUB_TOKEN} | docker login ghcr.io -u USERNAME --password-stdin
	docker push ghcr.io/dfe-digital/get-into-teaching-app-maintenance:${MAINTENANCE_IMAGE_TAG}

maintenance-fail-over: get-cluster-credentials
	$(eval export CONFIG)
	./maintenance_page/scripts/failover.sh

enable-maintenance: maintenance-image-push maintenance-fail-over

disable-maintenance: get-cluster-credentials
	$(eval export CONFIG)
	./maintenance_page/scripts/failback.sh
