DIR_GIT=$(shell sh -c "git rev-parse --show-toplevel")

all: help

##@ Docs Generation
doc: README.md ## Generates Terraform docs for modules
	$(call info_colors,blue,📄 Terraform docs)
	@terraform-docs .

##@ Checks
precommit: ## Runs precommit on all files
	$(call info_colors,green,👍 Pre-commit checks)
	@pre-commit run --all-files && echo "Pre-commit checks passed" || echo "Pre-commit checks failed"

##@ Formating	
format: ## Runs Terraform fmt and Validate
	terraform fmt
	terraform validate

##@ Commit
commit: ## Commits all files
	$(call info_colors,purple,🛍 Commits Changed files)
	@git add .
	@echo "Modified files:"
	@git status -s
	@git cz

cz: doc precommit commit  ## Runs Docs, precommit and commits

##@ Terraform
plan: ## Plan in the tooling folder
	$(call info_colors,green,🗺 Terraform Plan)
	@cd $(DIR_GIT)/tooling && terraform init && terraform plan

apply: ## Apply in the tooling folder
	$(call info_colors,green,👏 Terraform Apply)
	@cd $(DIR_GIT)/tooling && terraform init && terraform apply


include $(DIR_GIT)/prettier.mk

.PHONY: all doc format
