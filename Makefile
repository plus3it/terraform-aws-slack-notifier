SHELL := /bin/bash

include $(shell test -f .tardigrade-ci || curl -sSL -o .tardigrade-ci "https://raw.githubusercontent.com/plus3it/tardigrade-ci/master/bootstrap/Makefile.bootstrap"; echo .tardigrade-ci)

clean/node:
	rm -rf ./node_modules ./vendor

package: clean/node
	npm install --production  # Creates node_modules and downloads/installs dependencies from package.json
	mkdir -p ./vendor
	mv ./node_modules/aws-to-slack ./vendor
	mv ./node_modules ./vendor
