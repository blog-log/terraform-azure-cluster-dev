init:
	terraform init

fmt:
	terraform fmt

refresh:
	terraform refresh -var-file="data.tfvars"

plan:
	terraform plan -var-file="data.tfvars"

apply:
	terraform apply -var-file="data.tfvars"

destroy:
	terraform destroy -var-file="data.tfvars"

get_creds:
	az aks get-credentials --resource-group dev-k8s-resources --name dev-k8s