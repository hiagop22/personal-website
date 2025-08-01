output "cdn_url" {
  value = aws_cloudfront_distribution.this.domain_name
}

output "distribution-id" {
  value = aws_cloudfront_distribution.this.id
}

output "cdn_oai" {
  value = aws_cloudfront_origin_access_identity.origin_access_identity.id
}

output "domain_name" {
  value = aws_cloudfront_distribution.this.domain_name
}

output "zone_id" {
  value = aws_cloudfront_distribution.this.hosted_zone_id
}