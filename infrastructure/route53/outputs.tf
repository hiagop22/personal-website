output "fqdns" {
  value = [aws_route53_record.website[0].fqdn, aws_route53_record.www[0].fqdn]
}