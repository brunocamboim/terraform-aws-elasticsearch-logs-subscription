provider "aws" {
  region = var.region
}

terraform {
  backend "s3" {
    encrypt = true
    bucket  = "terraform-remotestate-dev"
    region  = "us-east-1"
    key     = "audit-state"
  }
}

variable "region" {
  default = "us-east-1"
}

variable "env" {
  default = "dev"
}

variable "lambda_audit_function_name" {
  default = "LogsToElasticsearch_-audit"
}

variable "elasticsearch_instance_type" {
  default = "t2.small.elasticsearch"
}

variable "vpc_cidr_block" {
  default = "10.110.0.0/16"
}

variable "AWS_ES_VPC_ENDPOINT" {}