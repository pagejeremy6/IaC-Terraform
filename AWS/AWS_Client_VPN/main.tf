terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = var.aws_region

}

resource "aws_vpc" "main" {
  cidr_block = var.cidr_block_vpc
  tags       = var.resource_tags
}

resource "aws_subnet" "main_subnet" {
  vpc_id     = aws_vpc.main.id
  cidr_block = var.cidr_block_subnet
  tags       = var.resource_tags
}