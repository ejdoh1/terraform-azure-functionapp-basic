deploy: check-env
	terraform init; \
	terraform apply -auto-approve

build:
	dotnet build LocalFunctionProj/LocalFunctionProj.csproj /p:DeployOnBuild=true /p:DeployTarget=Package;CreatePackageOnPublish=true
	cd LocalFunctionProj/bin/Debug/netcoreapp3.1/Publish/ && zip -r ../../../sample.zip .

check-env:
	@for var in terraform az dotnet; do \
		if ! command -v $$var &> /dev/null; then \
			echo "$$var could not be found"; \
			exit 1; \
		fi; \
	done
	
test:
	@curl --silent `terraform output -raw api_url`?name=person | grep "Hello, person. This HTTP triggered function executed successfully." > /dev/null && echo "TEST PASS" || echo "TEST FAIL"

destroy:
	terraform init; \
	terraform destroy -auto-approve
