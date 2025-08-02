data "template_file" "s3-public-policy" {
  template = file("${path.module}/policy.json")
  vars = {
    bucket_name = var.domain
    cdn_oai     = var.cdn_oai
  }
}


resource "aws_s3_bucket_policy" "website" {
  bucket = var.website_id

  policy = data.template_file.s3-public-policy.rendered

  depends_on = [var.public_access_website]
}