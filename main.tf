# 1. AWS Provider Configuration
terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = "eu-central-1"
}

# 2. Create a unique S3 Bucket for the static website
resource "aws_s3_bucket" "site_bucket" {
  bucket = "portofoliu-cloud-2026"
}

# 3. Disable public access block to allow public viewing
resource "aws_s3_bucket_public_access_block" "public_access" {
  bucket                  = aws_s3_bucket.site_bucket.id
  block_public_acls       = false
  block_public_policy     = false
  ignore_public_acls      = false
  restrict_public_buckets = false
}

# 4. Bucket policy to grant public read-only access
resource "aws_s3_bucket_policy" "public_read_policy" {
  bucket = aws_s3_bucket.site_bucket.id

  policy = jsonencode({
    Version = "2012-10-17"
    Statement = [
      {
        Sid       = "PublicReadGetObject"
        Effect    = "Allow"
        Principal = "*"
        Action    = "s3:GetObject"
        Resource  = "${aws_s3_bucket.site_bucket.arn}/*"
      },
    ]
  })

  depends_on = [aws_s3_bucket_public_access_block.public_access]
}

# 5. Configure S3 bucket for static website hosting
resource "aws_s3_bucket_website_configuration" "website" {
  bucket = aws_s3_bucket.site_bucket.id

  index_document {
    suffix = "index.html"
  }
}

# 6. Upload index.html from local machine to S3
resource "aws_s3_object" "index_page" {
  bucket       = aws_s3_bucket.site_bucket.id
  key          = "index.html"
  source       = "index.html"
  content_type = "text/html"
  etag         = filemd5("index.html") # Auto-updates in S3 if local file changes
}

# 7. Upload style.css from local machine to S3
resource "aws_s3_object" "style_sheet" {
  bucket       = aws_s3_bucket.site_bucket.id
  key          = "style.css"
  source       = "style.css"
  content_type = "text/css"
  etag         = filemd5("style.css") # Auto-updates in S3 if local file changes
}

# 8. Output: Public URL to access the website
output "website_url" {
  value       = aws_s3_bucket_website_configuration.website.website_endpoint
  description = "Public URL for the static website"
}