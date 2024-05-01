terraform {
  backend "s3" {
  }
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "> 4.0"
    }
  }
}

provider "aws" {
  region = var.region
}

resource "aws_ecs_cluster" "nubble_cluster" {
  name = "my-ecs-cluster"
}