output "cloudfront_url" {
  value = aws_cloudfront_distribution.distribution.domain_name
}
