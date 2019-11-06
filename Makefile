BIN_DIR ?= ${HOME}/bin
PATH := $(BIN_DIR):${PATH}

MAKEFLAGS += --no-print-directory
SHELL := bash
.SHELLFLAGS := -eu -o pipefail -c
.SUFFIXES:

.PHONY: %/install %/lint

guard/program/%:
	@ which $* > /dev/null || $(MAKE) $*/install

$(BIN_DIR):
	@ echo "[make]: Creating directory '$@'..."
	mkdir -p $@

terraform/install: TERRAFORM_VERSION ?= $(shell curl -sSL https://checkpoint-api.hashicorp.com/v1/check/terraform | jq -r -M '.current_version')
terraform/install: TERRAFORM_URL ?= https://releases.hashicorp.com/terraform/$(TERRAFORM_VERSION)/terraform_$(TERRAFORM_VERSION)_linux_amd64.zip
terraform/install: | $(BIN_DIR)
	@ echo "[$@]: Installing $(@D)..."
	@ echo "[$@]: TERRAFORM_URL=$(TERRAFORM_URL)"
	curl -sSL -o terraform.zip "$(TERRAFORM_URL)"
	unzip terraform.zip && rm -f terraform.zip && chmod +x terraform
	mv terraform "$(BIN_DIR)"
	terraform --version
	@ echo "[$@]: Completed successfully!"

terraform/lint: | guard/program/terraform
	@ echo "[$@]: Linting Terraform files..."
	terraform fmt -check=true -diff=true
	@ echo "[$@]: Terraform files PASSED lint test!"

clean:
	rm -rf ./node_modules ./vendor

package: clean
	npm install --production  # Creates node_modules and downloads/installs dependencies from package.json
	mkdir -p ./vendor
	mv ./node_modules/aws-to-slack ./vendor
	mv ./node_modules ./vendor
