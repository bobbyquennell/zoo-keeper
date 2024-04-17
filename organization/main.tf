provider "aws" {
  region = "ap-southeast-2"
}

terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
      version = "~> 5.45"
    }
  }

  backend "s3" {
    bucket         = "logiczoo-terraform-state-zookeeper"
    key            = "logiczoo/zookeeper/organization/organization.tfstate"
    region         = "ap-southeast-2"
    dynamodb_table = "logiczoo-terraform-state-lock-zookeeper"
  }
}

# Create the AWS Organization
resource "aws_organizations_organization" "my_org" {
  feature_set                  = "ALL"
  enabled_policy_types         = ["SERVICE_CONTROL_POLICY", "TAG_POLICY"]
}

# Create the prod OU
resource "aws_organizations_organizational_unit" "prod_ou" {
  name = "Prod OU"
  parent_id = aws_organizations_organization.my_org.roots[0].id
}

# Create the "dev" OU
resource "aws_organizations_organizational_unit" "dev_ou" {
  name = "Dev OU"
  parent_id = aws_organizations_organization.my_org.roots[0].id
}

# Create the "prod" member account
resource "aws_organizations_account" "prod_account" {
  name  = var.prod_account_name
  email = var.prod_account_email
  role_name = "rootAccountUserAdminRole"
  parent_id = aws_organizations_organizational_unit.prod_ou.id
}

# Create the "dev" member account
resource "aws_organizations_account" "dev_account" {
  name  = var.dev_account_name
  email = var.dev_account_email
  role_name = "rootAccountUserAdminRole"
  parent_id = aws_organizations_organizational_unit.dev_ou.id
}