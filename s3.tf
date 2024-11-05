
resource "aws_s3_bucket" "this" {
  bucket = local.s3.bucket_name 
  
 
}
resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}



module "template_files" {
  source = "hashicorp/dir/template"

  base_dir = "${path.module}/frontend/html"
}
resource "aws_s3_bucket_website_configuration" "this" {
  bucket = aws_s3_bucket.this.id

  index_document {
    suffix = "index.html"
  }
}
resource "aws_s3_object" "Bucket_files" {
  bucket = aws_s3_bucket.this.id

  for_each     = module.template_files.files
  key          = each.key
  content_type = each.value.content_type

  source  = each.value.source_path
  content = each.value.content

  etag = each.value.digests.md5
}



resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id

  policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [
      {
        "Sid"       = "PublicReadGetObject",
        "Effect"    = "Allow",
        "Principal" = "*",
        "Action"    = "s3:GetObject",
        "Resource"  = "${aws_s3_bucket.this.arn}/*"
      },
      {
        "Sid"       = "CloudFrontGetObject",
        "Effect"    = "Allow",
        "Principal" = {
          "Service" = "cloudfront.amazonaws.com"  
        },
        "Action"    = "s3:GetObject",
        "Resource"  = "${aws_s3_bucket.this.arn}/*"  
      }
    ]
  })
}