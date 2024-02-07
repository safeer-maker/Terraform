terraform {
  required_providers {
    random = {
      source = "hashicorp/random"
      version = "3.6.0"
    }
  }
}

provider "random" {
  # Configuration options
}


resource "random_string" "bucket_name" {
  length  = 32
  special = false
  upper   = false
}

output "random_bucket_name" {
  value = random_string.bucket_name.result
}
