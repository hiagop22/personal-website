variable "aws_region" {
  type        = string
  description = ""
  default     = "us-east-1"
}

variable "aws_profile" {
  type        = string
  description = ""
  default     = "personal"
}

variable "domain" {
  type        = string
  description = ""
  default     = "aih.dev.br"
}

variable "website_path" {
  type        = string
  description = ""
  default     = "../website/dist/personal-website/browser"
}

