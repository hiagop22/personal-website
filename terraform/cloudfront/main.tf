resource "aws_cloudfront_origin_access_identity" "origin_access_identity" {
  comment = var.domain
}

resource "aws_cloudfront_distribution" "this" {
  enabled             = true
  is_ipv6_enabled     = true
  comment             = "Managed by Terraform"
  default_root_object = "index.html"
  aliases             = var.has_domain ? [var.domain, "www.${var.domain}"] : []

  logging_config {
    bucket          = "${var.domain}-log.s3.amazonaws.com"
    prefix          = "cdn/"
    include_cookies = true
  }

  default_cache_behavior {
    allowed_methods        = ["HEAD", "GET", "OPTIONS"]
    cached_methods         = ["HEAD", "GET"]
    target_origin_id       = var.regional_domain
    viewer_protocol_policy = "redirect-to-https"

    min_ttl     = 0
    default_ttl = 60  # 60 = 1 min
    max_ttl     = 120 #3600 =  1 hora

    forwarded_values {
      query_string = false
      headers      = ["Origin"]
      cookies {
        forward = "none"
      }
    }

  }

  origin {
    domain_name = var.regional_domain
    origin_id   = var.regional_domain

    s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.origin_access_identity.cloudfront_access_identity_path
    }
  }


  restrictions {
    geo_restriction {
      restriction_type = "none"
    }
  }

  # executa se não tiver o dominio
  dynamic "viewer_certificate" {
    for_each = var.has_domain ? [] : [0]

    content {
      cloudfront_default_certificate = true
    }
  }

  # executa se tiver o dominio
  dynamic "viewer_certificate" {
    for_each = var.has_domain ? [0] : []

    content {
      acm_certificate_arn      = var.acm_arn
      ssl_support_method       = "sni-only"
      minimum_protocol_version = "TLSv1.2_2021"
    }
  }

  depends_on = [var.s3_acl_log]
}
