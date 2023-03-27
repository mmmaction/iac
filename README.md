# iac
project to show basic concepts of infrastructure as code

it shows some simple example for `terraform` and `cloudformation`.

## terraform

https://developer.hashicorp.com/terraform

### get started

- install: e.g. on windows git bash: C:\Program Files (x86)\terraform -> doownload or update terraform.exe there (see https://developer.hashicorp.com/terraform/downloads)
- install AWS CLI / have AWS account available (e.g. free tier)
- create *.tf file and add provider and resources as a starting point
- google terraform *resource* -> eg. `terraform S3` -> should lead you quickly to resource specification
- write the resource specification in the *.tf file
- e.g.
  ```tf 
  resource "aws_s3_bucket" "example-bucket" {
    bucket = "iac-simple-bucket-1"
  }
  ```
- for seeing detailed logs: set terraform log level to trace
  -  `export  TF_LOG=TRACE`

#### s3 bucket

```bash
cd `/terraform/s3` directory
# initialize working directory and install required plugins
terraform init
# get a preview of the planned changes (optional)
terraform plan
# deploy the plan / s3 bucket (add -auto-approve for automatic creation)
terraform apply
# destroy the infra / s3 bucket (add -auto-approve for automatic creation)
terraform destroy
```

#### blob storage

instead of aws account and cli -> one needs to setup an azure account and the azure cli

```bash
cd `/terraform/blob` directory
# initialize working directory and install required plugins
terraform init
# get a preview of the planned changes (optional) -> save  plan to a file using out option.
terraform plan -out=tfplan
# deploy the plan / blob storage (add -auto-approve for automatic creation)
terraform apply tfplan
# destroy the infra / blob storage (add -auto-approve for automatic creation)
terraform destroy
```


## cloudformation

https://docs.aws.amazon.com/cloudformation/index.html

### get started

- install AWS CLI / have AWS account available (e.g. free tier)
- google cloudformation *resource* -> eg. `cloudformation S3` -> should lead you quickly to resource specification
- write the resource specification in the yaml or json file
- e.g.
  ```yaml
  Resources:
    simplebucket:
      Type: AWS::S3::Bucket
  ```

#### s3 bucket

```bash
cd /cloudformation/s3 directory
# optional: for creating changesets (type=CREATE)
aws cloudformation create-change-set --template-body file://s3.yaml --stack-name s3-deploy --change-set-name s3-changeset --change-set-type CREATE
# optional: for creating changesets (type=UPDATE)
aws cloudformation create-change-set --template-body file://s3.yaml --stack-name s3-deploy --change-set-name s3-changeset --change-set-type UPDATE
# optional: for executing changesets
aws cloudformation execute-change-set --stack-name s3-deploy --change-set-name s3-changeset
# for creating deploying a stack / the s3 bucket
aws cloudformation deploy --template-file s3.yaml --stack-name s3-deploy
# for deleting an existing stack / the s3 bucket
aws cloudformation delete-stack --stack-name s3-deploy
```

## azure resource manager

https://learn.microsoft.com/en-us/azure/azure-resource-manager/

### get started

- install Azure CLI / have Azure account available
- create a json file (e.g. using VS code and arm snippets)
- google azure *resource* -> eg. `azure blob storage` -> should lead you quickly to resource specification
- write the resource specification in the *.json file

#### blob storage

The following should deploy an storage account plus a blob storage container (additional specification needed for blob storage itself)

```bash
  cd /arm/blob directory
  az login
  az group create --name ExampleGroup --location "switzerlandnorth"
  # add what-if option for preview
  az deployment group create --resource-group ExampleGroup --template-file blob.json
  # remove everything within a resource group
  az group delete --name ExampleGroup
```

## aws CDK

https://docs.aws.amazon.com/cdk/v2/guide/home.html

### getting started

- install aws cdk toolkik: npm install -g aws-cdk
- npm run build
- cdk bootstrap
- cdk deploy

## background info

### tools
depending on the use case (provisioning, configuration mgmt, security, ..) there are different tools

Here some big players:
- terraform / terraform CDK
- aws cloudformation / CDK
- azure resource manager
- ansible
- chef
- puppet
- pulumi
- ...

### history
the following facts lead to iac imho:
- increasing number of servers, infrastructue
- emerging of cloud technologies
- learnings from software engineering and best practices like version control, DRY, automation, testing,...

### timeline

| Year | What
| -----| -------
| 1993 | CFEngine
| 2005 | Puppet
| 2009 | Chef
| 2010 | AWS Cloudformation
| 2011 | Saltstack, Openshift
| 2012 | Ansible
| 2013 | Docker
| 2014 | Terraform, Kubernetes, Azure Resoure Manager
| 2017 | Pulumi
| 2019 | AWS CDK
| 2020 | Azure Bicep
| 2022 | CDK for Terraform

### benefits
Here some benefits you gain using IaC:
- version control
- reproducability
- fast provisioning
- testability

### challenges
there are usually two sides of the coin here some things to consider
- Additional complexity (learning curve)
- "drifts"
- Specialities depending on cloud provider
- Everything as IaC?  (e.g. ad hoc dashboard for troubleshooting?)
- Avoid wild west -> naming conventions, good tagging if multiple teams involved
- Cloud orphans, cleanup may be required
- Is vendor lock in a problem?
- Debugging

