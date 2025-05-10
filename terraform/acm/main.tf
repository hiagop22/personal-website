resource "aws_acm_certificate" "this" {
  count = var.has_domain ? 1 : 0

  domain_name               = var.domain
  validation_method         = "DNS"
  subject_alternative_names = ["*.${var.domain}"]

  lifecycle {
    create_before_destroy = true
  }
}

data "aws_route53_zone" "this" {
  # count: se não tem domínio cria, senão não cria
  count = var.has_domain ? 1 : 0

  # necessário o . para informar que é uma hosted zone
  name = "${var.domain}."
}

resource "aws_route53_record" "ssl_cert_validation_records" {
  for_each = {
    for dvo in aws_acm_certificate.this[0].domain_validation_options : dvo.domain_name => {
      name   = dvo.resource_record_name
      record = dvo.resource_record_value
      type   = dvo.resource_record_type
    }
  }

  allow_overwrite = true
  name            = each.value.name
  records         = [each.value.record]
  ttl             = 60
  type            = each.value.type
  zone_id         = data.aws_route53_zone.this[0].zone_id

}