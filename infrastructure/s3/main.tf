

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

resource "aws_s3_object" "placeholder_index" {
  bucket = aws_s3_bucket.website.id
  key    = "index.html"

  content = "<html><body><h1>Website not deployed yet</h1></body></html>"

  content_type = "text/html"

  lifecycle {
    ignore_changes = [
      content,
      source,
      etag,
      tags
    ]
  }
}

resource "aws_s3_bucket_public_access_block" "website" {
  bucket = aws_s3_bucket.website.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
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
