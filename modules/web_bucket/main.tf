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

resource "aws_s3_object" "s3_upload_error" {
  bucket = aws_s3_bucket.web_bucket.bucket
  key    = "error.html"
  source = "temp/error.html"
  content_type = "text/html"
  etag = filemd5("temp/error.html")
  
  lifecycle {
    replace_triggered_by = [terraform_data.content_version.output]
    ignore_changes = [etag]
  }
}

resource "aws_s3_object" "s3_upload_index" {
  bucket        = aws_s3_bucket.web_bucket.bucket
  key           = "index.html"
  source        = "temp/index.html"
  content_type  = "text/html"
  etag            = filemd5("temp/index.html")

  lifecycle {
    replace_triggered_by = [terraform_data.content_version.output]
    ignore_changes = [etag]
  }
}

resource "terraform_data" "content_version" {
      input = var.content_version
}

data "aws_caller_identity" "current" {}

resource "aws_s3_bucket_policy" "bucket_policy" {
  bucket = aws_s3_bucket.web_bucket.bucket
  policy = jsonencode({
    "Version"= "2012-10-17",
    "Statement"= {
        "Sid"= "AllowCloudFrontServicePrincipalReadOnly",
        "Effect"= "Allow",
        "Principal"= {
            "Service"= "cloudfront.amazonaws.com"
        },
        "Action"= "s3:GetObject",
        "Resource"= "arn:aws:s3:::${aws_s3_bucket.web_bucket.id}/*",
        "Condition"= {
            "StringEquals"= {
                "AWS:SourceArn"= "arn:aws:cloudfront::${data.aws_caller_identity.current.account_id}:distribution/${aws_cloudfront_distribution.s3_distribution.id}"
            }
        }
    }
  })
}

resource "aws_cloudfront_origin_access_control" "cloudfront_s3_oac" {
  name                              = "s3_oac"
  description                       = "Example Policy"
  origin_access_control_origin_type = "s3"
  signing_behavior                  = "always"
  signing_protocol                  = "sigv4"
}

resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name              = aws_s3_bucket.web_bucket.bucket_regional_domain_name
    origin_access_control_id = aws_cloudfront_origin_access_control.cloudfront_s3_oac.id
    origin_id                = "MyS3Origin" //aws_s3_bucket_website_configuration.s3_static_website.website_endpoint
  }

  enabled             = true
  is_ipv6_enabled     = true
  comment             = "cdn for s3 ${var.web_bucket_name} bucket"
  default_root_object = "index.html"


  default_cache_behavior {
    allowed_methods  = ["DELETE", "GET", "HEAD", "OPTIONS", "PATCH", "POST", "PUT"]
    cached_methods   = ["GET", "HEAD"]
    target_origin_id = "MyS3Origin" //"local.s3_origin_id"

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }

    viewer_protocol_policy = "allow-all"
    min_ttl                = 0
    default_ttl            = 3600
    max_ttl                = 86400
  }

  price_class = "PriceClass_200"

  restrictions {
    geo_restriction {
      restriction_type = "none"
      locations        = []
    }
  }

  tags = {
    Name        = var.team
    Environment = var.environment
  }

  viewer_certificate {
    cloudfront_default_certificate = true
  }
}

