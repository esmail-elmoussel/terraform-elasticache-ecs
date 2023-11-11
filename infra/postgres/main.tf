terraform {
  backend "remote" {
    organization = "esmail-elmoussel"

    workspaces {
      name = "sample-postgres"
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

module "security_groups" {
  source = "./modules/security-groups"
}

module "rds" {
  source            = "./modules/rds"
  security_group_id = module.security_groups.sample_app_postgres_security_group_id

  depends_on = [module.security_groups]
}


