terraform {
    required_providers {
      aws = {
      source = "hashicorp/aws"
      version = "5.36.0"
      }
  }
}

resource "aws_s3_bucket" "web_bucket" {
  bucket = var.web_bucket_name

  tags = {
    Name        = var.team
    Environment = var.environment
  }
} 

resource "aws_s3_bucket_website_configuration" "s3_static_website" {
  bucket = var.web_bucket_name

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "error.html"
  }
}

resource "aws_s3_object" "s3_upload_index" {
  bucket = var.web_bucket_name
  key    = "index.html"
  source = "temp/index.html"
  content_type = "text/html"
  etag = filemd5("temp/index.html")
}