init-prod:
	terraform init -backend-config=./environments/prod/backend.tfvars

plan-prod:
	terraform plan --var-file=./environments/prod/variables.tfvars

apply-prod:
	terraform apply --var-file=./environments/prod/variables.tfvars
