resource "aws_acm_certificate" "this" {
  count = var.has_domain ? 1 : 0

  domain_name               = var.domain
  validation_method         = "EMAIL"
  subject_alternative_names = ["*.${var.domain}"]

  lifecycle {
    create_before_destroy = true
  }
}

resource "aws_acm_certificate_validation" "this" {
  count = var.has_domain ? 1 : 0

  certificate_arn = aws_acm_certificate.this[0].arn
  #   validation_record_fqdns = [aws_route53_record.cert_validation.fqdn]
}