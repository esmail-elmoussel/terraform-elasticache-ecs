generate "backend" {
  path      = "terragrunt-auto-generated-backend.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<EOF
terraform {
  backend "remote" {
    organization = "esmail-elmoussel"

    workspaces {
      name = "${path_relative_to_include()}"
    }
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.24.0"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region     = "us-east-1"
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
}
EOF
}

generate "aws_variables" {
  path      = "terragrunt-auto-generated-variables.tf"
  if_exists = "overwrite_terragrunt"

  contents = <<EOF
variable "aws_access_key" {
  description = "AWS Access Key"
  type        = string
}

variable "aws_secret_key" {
  description = "AWS Secret Key"
  type        = string
}
EOF
}
