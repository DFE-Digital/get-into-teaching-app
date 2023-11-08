TERRAFILE_VERSION=0.8
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

.PHONY: development
development:
	$(eval export DEPLOY_ENV=dev)
	$(eval export KEY_VAULT=s146d01-kv)
	$(eval export AZURE_SUBSCRIPTION=s146-getintoteachingwebsite-development)

.PHONY: local
local:
	$(eval export KEY_VAULT=s146d01-local2-kv)
	$(eval export AZURE_SUBSCRIPTION=s146-getintoteachingwebsite-development)

.PHONY: review
review:
	$(if $(PR_NUMBER), , $(error Missing environment variable "PR_NUMBER", Please specify a pr number for your review app))
	$(eval export PR_NAME=review-get-into-teaching-app-${PR_NUMBER})
	$(eval export DEPLOY_ENV=review)
	$(eval export KEY_VAULT=s146d01-kv)
	$(eval export AZURE_SUBSCRIPTION=s146-getintoteachingwebsite-development)
	$(eval BACKEND_KEY=-backend-config=key=${PR_NAME}.tfstate)
	$(eval export TF_VAR_paas_app_application_name=${PR_NAME})
	$(eval export TF_VAR_paas_app_route_name=${PR_NAME})

.PHONY: test
test:
	$(eval export DEPLOY_ENV=staging)
	$(eval export KEY_VAULT=s146t01-kv)
	$(eval export AZURE_SUBSCRIPTION=s146-getintoteachingwebsite-test)

.PHONY: production
production:
	$(eval export DEPLOY_ENV=production)
	$(eval export KEY_VAULT=s146p01-kv)
	$(eval export AZURE_SUBSCRIPTION=s146-getintoteachingwebsite-production)

.PHONY: review_aks
review_aks: test-cluster
	$(if $(PR_NUMBER), , $(error Missing environment variable "PR_NUMBER", Please specify a pr number for your review app))
	$(eval include global_config/review_aks.sh)
	$(eval export DEPLOY_ENV=review)
	$(eval export TF_VAR_pr_number=-${PR_NUMBER})

.PHONY: development_aks
development_aks: test-cluster
	$(eval include global_config/development_aks.sh)

.PHONY: test_aks
test_aks: test-cluster
	$(eval include global_config/test_aks.sh)

.PHONY: production_aks
production_aks: production-cluster
	$(eval include global_config/production_aks.sh)

.PHONY: beta_aks
beta_aks: production-cluster
	$(eval include global_config/beta_aks.sh)

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

edit-app-secrets: install-fetch-config set-azure-account
	./fetch_config.rb -s azure-key-vault-secret:${KEY_VAULT}/${APPLICATION_SECRETS} -e -d azure-key-vault-secret:${KEY_VAULT}/${APPLICATION_SECRETS} -f yaml -c

print-app-secrets: install-fetch-config set-azure-account
	./fetch_config.rb -s azure-key-vault-secret:${KEY_VAULT}/${APPLICATION_SECRETS}  -f yaml

edit-ps-secrets: install-fetch-config set-azure-account
	./fetch_config.rb -s azure-key-vault-secret:${KEY_VAULT}/${PAGESPEED_SECRETS} -e -d azure-key-vault-secret:${KEY_VAULT}/${PAGESPEED_SECRETS} -f yaml -c

print-ps-secrets: install-fetch-config set-azure-account
	./fetch_config.rb -s azure-key-vault-secret:${KEY_VAULT}/${PAGESPEED_SECRETS}  -f yaml

edit-infra-secrets: install-fetch-config set-azure-account
	./fetch_config.rb -s azure-key-vault-secret:${KEY_VAULT}/${INFRA_SECRETS} -e -d azure-key-vault-secret:${KEY_VAULT}/${INFRA_SECRETS} -f yaml -c

print-infra-secrets: install-fetch-config set-azure-account
	./fetch_config.rb -s azure-key-vault-secret:${KEY_VAULT}/${INFRA_SECRETS}  -f yaml

setup-local-env: install-fetch-config set-azure-account
	./fetch_config.rb -s yaml-file:.env.development.yml -s azure-key-vault-secret:s146d01-local2-kv/${APPLICATION_SECRETS} -f shell-env-var > .env.development

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

bin/terrafile: ## Install terrafile to manage terraform modules
	curl -sL https://github.com/coretech/terrafile/releases/download/v${TERRAFILE_VERSION}/terrafile_${TERRAFILE_VERSION}_$$(uname)_x86_64.tar.gz \
		| tar xz -C ./bin terrafile

bin/konduit.sh:
	curl -s https://raw.githubusercontent.com/DFE-Digital/teacher-services-cloud/main/scripts/konduit.sh -o bin/konduit.sh \
		&& chmod +x bin/konduit.sh

terraform-init: set-azure-account
	$(if $(or $(IMAGE_TAG), $(NO_IMAGE_TAG_DEFAULT)), , $(eval export IMAGE_TAG=master))
	$(if $(IMAGE_TAG), , $(error Missing environment variable "IMAGE_TAG"))
	$(eval export TF_VAR_paas_app_docker_image=ghcr.io/dfe-digital/get-into-teaching-frontend:$(IMAGE_TAG))

	terraform -chdir=terraform/paas init -reconfigure -backend-config=${DEPLOY_ENV}.bk.vars ${BACKEND_KEY}

terraform-plan: terraform-init
	terraform -chdir=terraform/paas plan -var-file=${DEPLOY_ENV}.env.tfvars

terraform: terraform-init
	terraform -chdir=terraform/paas apply -var-file=${DEPLOY_ENV}.env.tfvars ${AUTO_APPROVE}

terraform-destroy: terraform-init
	terraform -chdir=terraform/paas destroy -var-file=${DEPLOY_ENV}.env.tfvars ${AUTO_APPROVE}

delete-state-file:
	az storage blob delete --container-name pass-tfstate --delete-snapshots include --account-name s146d01sgtfstate -n ${PR_NAME}.tfstate

terraform-init-aks: composed-variables bin/terrafile set-azure-account
	$(if ${DOCKER_IMAGE_TAG}, , $(eval DOCKER_IMAGE_TAG=master))
	$(if $(PR_NUMBER), $(eval KEY_PREFIX=$(PR_NUMBER)), $(eval KEY_PREFIX=$(ENVIRONMENT)))

	./bin/terrafile -p terraform/aks/vendor/modules -f terraform/aks/config/$(CONFIG)_Terrafile
	terraform -chdir=terraform/aks init -upgrade -reconfigure \
		-backend-config=resource_group_name=${RESOURCE_GROUP_NAME} \
		-backend-config=storage_account_name=${STORAGE_ACCOUNT_NAME} \
		-backend-config=key=${KEY_PREFIX}.tfstate

	$(eval export TF_VAR_azure_resource_prefix=${AZURE_RESOURCE_PREFIX})
	$(eval export TF_VAR_config_short=${CONFIG_SHORT})
	$(eval export TF_VAR_service_name=${SERVICE_NAME})
	$(eval export TF_VAR_service_short=${SERVICE_SHORT})
	$(eval export TF_VAR_docker_image=${DOCKER_REPOSITORY}:${DOCKER_IMAGE_TAG})

terraform-plan-aks: terraform-init-aks
	terraform -chdir=terraform/aks plan -var-file "config/${CONFIG}.tfvars.json"

terraform-apply-aks: terraform-init-aks
	terraform -chdir=terraform/aks apply -var-file "config/${CONFIG}.tfvars.json" ${AUTO_APPROVE}

terraform-destroy-aks: terraform-init-aks
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

domains-infra-init: bin/terrafile domains-composed-variables set-azure-account
	./bin/terrafile -p terraform/domains/infrastructure/vendor/modules -f terraform/domains/infrastructure/config/zones_Terrafile

	terraform -chdir=terraform/domains/infrastructure init -reconfigure -upgrade \
		-backend-config=resource_group_name=${RESOURCE_GROUP_NAME} \
		-backend-config=storage_account_name=${STORAGE_ACCOUNT_NAME} \
		-backend-config=key=domains_infrastructure.tfstate

domains-infra-plan: domains domains-infra-init ## Terraform plan for DNS infrastructure (zone and front door. Usage: make domains-infra-plan
	terraform -chdir=terraform/domains/infrastructure plan -var-file config/zones.tfvars.json

domains-infra-apply: domains domains-infra-init ## Terraform apply for DNS infrastructure (zone and front door). Usage: make domains-infra-apply
	terraform -chdir=terraform/domains/infrastructure apply -var-file config/zones.tfvars.json ${AUTO_APPROVE}

domains-init: bin/terrafile domains-composed-variables set-azure-account
	./bin/terrafile -p terraform/domains/environment_domains/vendor/modules -f terraform/domains/environment_domains/config/${ENVIRONMENT}_Terrafile

	terraform -chdir=terraform/domains/environment_domains init -upgrade -reconfigure \
		-backend-config=resource_group_name=${RESOURCE_GROUP_NAME} \
		-backend-config=storage_account_name=${STORAGE_ACCOUNT_NAME} \
		-backend-config=key=${ENVIRONMENT}.tfstate

domains-plan: domains domains-init ## Terraform plan for DNS environment domains. Usage: make development_aks domains-plan
	terraform -chdir=terraform/domains/environment_domains plan -var-file config/${ENVIRONMENT}.tfvars.json

domains-apply: domains domains-init ## Terraform apply for DNS environment domains. Usage: make development_aks domains-apply
	terraform -chdir=terraform/domains/environment_domains apply -var-file config/${ENVIRONMENT}.tfvars.json ${AUTO_APPROVE}

test-cluster:
	$(eval CLUSTER_RESOURCE_GROUP_NAME=s189t01-tsc-ts-rg)
	$(eval CLUSTER_NAME=s189t01-tsc-test-aks)

production-cluster:
	$(eval CLUSTER_RESOURCE_GROUP_NAME=s189p01-tsc-pd-rg)
	$(eval CLUSTER_NAME=s189p01-tsc-production-aks)

get-cluster-credentials: set-azure-account
	az aks get-credentials --overwrite-existing -g ${CLUSTER_RESOURCE_GROUP_NAME} -n ${CLUSTER_NAME}

edit-app-secrets-aks: install-fetch-config set-azure-account
	./fetch_config.rb -s azure-key-vault-secret:${AZURE_RESOURCE_PREFIX}-${SERVICE_SHORT}-${CONFIG_SHORT}-app-kv/${APPLICATION_SECRETS} -e -d azure-key-vault-secret:${AZURE_RESOURCE_PREFIX}-${SERVICE_SHORT}-${CONFIG_SHORT}-app-kv/${APPLICATION_SECRETS} -f yaml -c

print-app-secrets-aks: install-fetch-config set-azure-account
	./fetch_config.rb -s azure-key-vault-secret:${AZURE_RESOURCE_PREFIX}-${SERVICE_SHORT}-${CONFIG_SHORT}-app-kv/${APPLICATION_SECRETS}  -f yaml
