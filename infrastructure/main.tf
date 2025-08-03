terraform {
  required_version = "1.11.1"
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "6.7.0"
    }
  }
  backend "s3" {
    bucket         = "backend-aihdev"
    key            = "static-website/terraform.tfstate"
    region         = "us-east-1"
    use_lockfile   = true
  }
}



provider "aws" {
  region  = var.aws_region
  default_tags {
    tags = {
      Project      = "AWS with Terraform"
      Service      = "Static Website"
      CreatedAt    = "2024-03-16"
    }
  }
}

module "s3" {
  source         = "./s3"
  domain         = var.domain
  web_build_path = var.web_build_path
  web_root_path  = var.web_root_path
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
  source                    = "./route53"
  domain                    = var.domain
  has_domain                = local.has_domain
  hosted_zone_id            = module.cloudfront.zone_id
  domain_name               = module.cloudfront.domain_name
}

module "iam" {
  source                = "./iam"
  domain                = var.domain
  website_id            = module.s3.website_id
  cdn_oai               = module.cloudfront.cdn_oai
  public_access_website = module.s3.public_access_website
}
