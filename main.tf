terraform {

  # cloud {
  #     organization = "safeerahmad"
  #     workspaces {
  #       name = "safeer-tf"
  #     }
  # }

  # required_providers {
  #     random = {
  #     source = "hashicorp/random"
  #     version = "3.6.0"
  #     }

  #     aws = {
  #     source = "hashicorp/aws"
  #     version = "5.36.0"
  #     }
  # }
}

module "web_bucket" {
  source = "./modules/web_bucket"
  team = var.team 
  environment = var.environment
  web_bucket_name = var.web_bucket_name
    
}

# provider "random" {
#   # Configuration options
# }

# provider "aws" {
#   # Configuration options
# }
 
# resource "random_string" "bucket_name" {
#   length  = 32
#   special = false
#   upper   = false
# }

# resource "aws_s3_bucket" "example" {
#   bucket = random_string.bucket_name.result

#   tags = {
#     Name        = var.team
#     Environment = var.environment
#   }
# } 




