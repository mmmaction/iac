terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.16"
    }
  }

  required_version = ">= 1.2.0"
}

provider "aws" {
  region  = "eu-west-1"

  # define default tags for all resources
  default_tags {
    tags = {
      Project     = local.tag_project
      Owner       = local.tag_owner
    }
  }
  
}
