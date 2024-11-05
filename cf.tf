resource "aws_cloudfront_distribution" "s3_distribution" {
  origin {
    domain_name = aws_s3_bucket.this.bucket_regional_domain_name  
    origin_id   = "S3Origin"  
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

    viewer_protocol_policy = "allow-all" 
    min_ttl                = 0
    default_ttl            = 3600  
    max_ttl                = 86400  
  }

  price_class = "PriceClass_200" 

  restrictions {
    geo_restriction {
      restriction_type = "none"  
    }
  }

  viewer_certificate {
    cloudfront_default_certificate = true 
  }
}
