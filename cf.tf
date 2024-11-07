resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.this.bucket_regional_domain_name  
    origin_id   = "S3Origin"  
     s3_origin_config {
      origin_access_identity = aws_cloudfront_origin_access_identity.cloudfront_origin_access_identity.cloudfront_access_identity_path
    }
  }

  enabled         = true
  is_ipv6_enabled = false
  default_root_object = "index.html"
  
  

  default_cache_behavior {
    allowed_methods = ["GET", "HEAD"]  
    cached_methods  = ["GET", "HEAD"]
    target_origin_id = "S3Origin"  

    forwarded_values {
      query_string = false

      cookies {
        forward = "none"
      }
    }
    viewer_protocol_policy = "redirect-to-https"
    min_ttl                = 0
    default_ttl            = 3600  
    max_ttl                = 86400  
  }
aliases = ["app-jarvis-test.aftl.biz"]
  price_class = "PriceClass_200" 

  restrictions {
    geo_restriction {
      restriction_type = "none"  
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true 
    acm_certificate_arn      = "arn:aws:acm:us-east-1:265697931443:certificate/34b754e4-f111-45c8-a914-dde2c2bfc80a"
    ssl_support_method       = "sni-only"
    minimum_protocol_version = "TLSv1.2_2021"
  }
}
resource "aws_cloudfront_origin_access_identity" "cloudfront_origin_access_identity" {
  comment    = aws_s3_bucket.this.id
}