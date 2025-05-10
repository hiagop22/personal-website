data "aws_route53_zone" "this" {
  # count: se não tem domínio cria, senão não cria
  count = var.has_domain ? 1 : 0

  # necessário o . para informar que é uma hosted zone
  name = "${var.domain}."
}


resource "aws_route53_record" "website" {
  count = var.has_domain ? 1 : 0

  name    = var.domain
  type    = "A"
  zone_id = data.aws_route53_zone.this[0].zone_id

  alias {
    evaluate_target_health = false
    name                   = var.domain_name
    zone_id                = var.hosted_zone_id
  }
}

resource "aws_route53_record" "www" {
  count = var.has_domain ? 1 : 0

  name    = "www.${var.domain}"
  type    = "A"
  zone_id = data.aws_route53_zone.this[0].zone_id

  alias {
    evaluate_target_health = false
    name                   = var.domain_name
    zone_id                = var.hosted_zone_id
  }
}

