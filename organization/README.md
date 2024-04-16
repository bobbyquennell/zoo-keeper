# Organization

this folder contains the code that defines the shared S3 and DynamoDB for remote state sharing and race-condition locking mechanism

## Prerequisites

* Install [Terraform](https://developer.hashicorp.com/terraform/install)
* you have access to the AWS account
* install one of the CLI tools to access the AWS account:
  * [granted](https://docs.commonfate.io/granted/getting-started)(recommended, great for multiple AWS accounts and SSO)
  
## Shared S3 Bucket

* **Default encryption:** `Enabled`
* **Server-side encryption:** `SSE-S3`

|Bucket Name | Description |
|--|--|
|logiczoo-terraform-state-zookeeper | for storing terraform state files remotely|

## Shared DynamoDB

|Table Name | Description |
|--|--|
|logiczoo-terraform-state-lock-zookeeper|Prevent the race condition when two team members are running Terraform at the same time. Updating a same state file concurrently will lead to conflicts, data loss, and state file corruption|

## How to run

```bash
> assume <your-aws-profile>
```

inside `remote-state` directory

```bash
> terraform init
> terraform plan
> terraform apply
```

### note

you only need to run this folder once, as it is used to initialize/scaffold the terraform in your AWS account.
