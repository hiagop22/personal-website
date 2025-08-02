output "web_url" {
  value = aws_s3_bucket_website_configuration.website.website_endpoint
}

output "regional_domain" {
  value = aws_s3_bucket.website.bucket_domain_name
}

output "website_id" {
  value = aws_s3_bucket.website.id
}

output "public_access_website" {
  value = aws_s3_bucket_public_access_block.website
}

output "s3_acl_log" {
  value = aws_s3_bucket_acl.log
}