terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.20.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}

locals {
  workload = "somecompany"
}

module "vpc" {
  source   = "./modules/vpc"
  workload = local.workload
  region   = var.aws_region
}

module "kms" {
  source = "./modules/kms"
}

module "aurora" {
  source      = "./modules/rds"
  workload    = local.workload
  vpc_id      = module.vpc.vpc_id
  subnets     = module.vpc.public_subnets
  kms_key_arn = module.kms.kms_key_arn
}
