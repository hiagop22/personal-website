output "website-domain" {
  value = var.domain
}

output "regional_domain" {
  value = module.s3.regional_domain
}

output "web-url" {
  value = module.s3.web_url
}

output "cdn-url" {
  value = module.cloudfront.cdn_url
}

output "distribution-id" {
  value = module.cloudfront.distribution-id
}

output "fileset-results" {
  value = fileset(var.website_path, "*")
}