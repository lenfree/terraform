# This contains targets to execute terraform such as bootstrap
#
# Usage:
# make help

BOOTSTRAP := "false"

.PHONY: set-backend
set-backend: dependency
	@echo "INFO: Configure Initial S3 backend for $(SITE)-remote_state-$(ENVIRONMENT)"
	terraform remote config -backend=s3 \
		-backend-config="bucket=$(SITE)-remote_state-$(ENVIRONMENT)" \
		-backend-config="key=$(MODULE)/terraform.tfstate" \
		-backend-config="region=us-east-1"
	@echo "Configure initial Terraform backend done"

.PHONY: dependency
dependency:
ifndef ENVIRONMENT
	$(error ENVIRONMENT is not set)
endif
ifndef SITE 
	$(error SITE is not set)
endif
ifndef MODULE 
	$(error MODULE is not set)
endif

help:
	@echo "Usage: make <command> ENVIRONMENT=<envinronment> SITE=<site>"
	@echo "  set-backend 		   Configure S3 backend to store statefile"
	@echo "                        ENVIRONMENT should be production e.g. ENVIRONMENT=production"
	@echo "                        SITE e.g. SITE=management"
	@echo "                        MODULE e.g. MODULE=vpc"
