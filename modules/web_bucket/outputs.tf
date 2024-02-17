output "bucket_name" {
  value = aws_s3_bucket.web_bucket.bucket
}

output "s3_bucket_link" {
  value = aws_s3_bucket_website_configuration.s3_static_website.website_endpoint
}
