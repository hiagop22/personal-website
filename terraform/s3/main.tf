

resource "aws_s3_bucket" "website" {
  bucket        = var.domain
  force_destroy = true
}


resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.website.id

  index_document {
    suffix = "index.html"
  }

  error_document {
    key = "index.html"
  }
}


resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# TERRAFORM DON`T WAIT THE NULL RESOURCE TO TRY UPLOADDING FILES. 
# SO BUILD MANUALLY, OR IT WILL CRASH ALL PROCESS
# resource "terraform_data" "angular_build" {
#   triggers_replace = {
#     layer_build = md5(join("-", [for x in fileset("${var.web_root_path}/src", local.md5_files_str) : filemd5(x)]))
#   }

#   provisioner "local-exec" {
#     working_dir = "${var.web_root_path}"
#     command = "ng build  --base-href 'https://${var.domain}'"
#   }
# }

resource "aws_s3_object" "upload_object" {
  for_each = fileset("${var.web_build_path}/", "**")

  bucket       = aws_s3_bucket.website.id
  key          = each.value
  source       = "${var.web_build_path}/${each.value}"
  etag         = filemd5("${var.web_build_path}/${each.value}")
  content_type = lookup(var.file_types, regex("\\.[^\\.]+\\z", "${var.web_build_path}/${each.value}"), var.default_file_type)

  # depends_on = [ terraform_data.angular_build ]
}


resource "aws_s3_bucket" "log" {
  bucket        = "${var.domain}-log"
  force_destroy = true
}

# Resource to avoid error "AccessControlListNotSupported: The bucket does not allow ACLs"
resource "aws_s3_bucket_ownership_controls" "s3_bucket_acl_ownership" {
  bucket = aws_s3_bucket.log.id
  rule {
    object_ownership = "ObjectWriter"
  }
}

resource "aws_s3_bucket_acl" "log" {
  bucket = aws_s3_bucket.log.id
  acl    = "log-delivery-write"

  depends_on = [aws_s3_bucket.log,
    aws_s3_bucket_ownership_controls.s3_bucket_acl_ownership
  ]
}

resource "aws_s3_bucket_logging" "log" {
  bucket = aws_s3_bucket.website.id

  target_bucket = aws_s3_bucket.log.id
  target_prefix = "log/"
}
