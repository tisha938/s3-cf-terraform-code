# Define the S3 bucket
resource "aws_s3_bucket" "this" {
  bucket = local.s3.bucket_name
}

# Enforce object ownership to bucket owner
resource "aws_s3_bucket_ownership_controls" "this" {
  bucket = aws_s3_bucket.this.id
  rule {
    object_ownership = "BucketOwnerEnforced"
  }
}

# Block public access to the S3 bucket
resource "aws_s3_bucket_public_access_block" "this" {
  bucket = aws_s3_bucket.this.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_policy" "this" {
  bucket = aws_s3_bucket.this.id

  policy = jsonencode({
    "Version" = "2012-10-17",
    "Statement" = [
      {
        "Sid"       = "CloudFrontGetObject",
        "Effect"    = "Allow",
        "Principal" = {
          "AWS" = "arn:aws:iam::cloudfront:user/CloudFront Origin Access Identity ${aws_cloudfront_origin_access_identity.cloudfront_origin_access_identity.id}"
        },
        "Action"    = "s3:GetObject",
        "Resource"  = "${aws_s3_bucket.this.arn}/*"
      }
    ]
  })
}
