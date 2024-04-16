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
