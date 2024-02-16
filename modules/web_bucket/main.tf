terraform {
    required_providers {
      aws = {
      source = "hashicorp/aws"
      version = "5.36.0"
      }
  }
}

# provider "aws" {
#   # Configuration options
# }

resource "aws_s3_bucket" "web_bucket" {
  bucket = var.web_bucket_name

  tags = {
    Name        = var.team
    Environment = var.environment
  }
} 
