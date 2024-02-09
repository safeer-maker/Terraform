terraform {

  # cloud {
  #     organization = "safeerahmad"
  #     workspaces {
  #       name = "safeer-tf"
  #     }
  # }
  # backend "remote" {
  #   hostname = "app.terraform.io"
  #   organization = "safeerahmad"

  #   workspaces {
  #     name =  "safeer-tf"
  #   }
  # }

  required_providers {
      random = {
      source = "hashicorp/random"
      version = "3.6.0"
      }

      aws = {
      source = "hashicorp/aws"
      version = "5.35.0"
      }
  }
}

provider "random" {
  # Configuration options
}

provider "aws" {
  # Configuration options
  # region     = "us-east-1"
  # access_key = "dgbzJNukLKt9UQrRsqDxZrQojWnTf4AU9Lz5mdgd"
  # secret_key = "AKIAUHMCCXJ6V3QJZQHQ"
}
 
resource "random_string" "bucket_name" {
  length  = 32
  special = false
  upper   = false
}

output "random_bucket_name" {
  value = random_string.bucket_name.result
}

resource "aws_s3_bucket" "example" {
  bucket = random_string.bucket_name.result
}

