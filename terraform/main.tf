terraform {
  required_version = "1.7.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "5.34.0"
    }
  }
  # backend "s3" {}
}

provider "aws" {
  profile = var.aws_profile
  region  = var.aws_region
  default_tags {
    tags = {
      Project      = "AWS com Terraform"
      Service      = "Static Website"
      CreatedAt    = "2024-03-16"
      LastUpdateAt = formatdate("YYYYMMDD", timestamp())
    }
  }
}

module "s3" {
  source       = "./s3"
  domain       = var.domain
  website_path = var.website_path
}

module "acm" {
  source     = "./acm"
  domain     = var.domain
  has_domain = local.has_domain
}

module "cloudfront" {
  source          = "./cloudfront"
  domain          = var.domain
  regional_domain = module.s3.regional_domain
  has_domain      = local.has_domain
  s3_acl_log      = module.s3.s3_acl_log
  acm_arn         = module.acm.acm_arn
}

module "route53" {
  source         = "./route53"
  domain         = var.domain
  has_domain     = local.has_domain
  hosted_zone_id = module.cloudfront.zone_id
  domain_name    = module.cloudfront.domain_name
}

module "iam" {
  source                = "./iam"
  domain                = var.domain
  website_id            = module.s3.website_id
  cdn_oai               = module.cloudfront.cdn_oai
  public_access_website = module.s3.public_access_website
}
