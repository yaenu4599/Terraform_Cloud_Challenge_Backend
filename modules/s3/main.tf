resource "aws_s3_bucket" "main" {
  bucket = var.bucket_main
  
  tags = merge(var.general_tags, {
    Name = "${var.environment}-resume-main-bucket"
  })
}

resource "aws_s3_bucket_versioning" "main" {
  bucket = aws_s3_bucket.main.id
  versioning_configuration {
    status = "Enabled"
  }
}

resource "aws_s3_bucket_public_access_block" "main" {
  bucket = aws_s3_bucket.main.id

  block_public_acls       = true
  block_public_policy     = true
  ignore_public_acls      = true
  restrict_public_buckets = true
}

resource "aws_s3_bucket_server_side_encryption_configuration" "main" {
  bucket = aws_s3_bucket.main.id

  rule {
    apply_server_side_encryption_by_default {
      sse_algorithm     = "AES256"
    }
  }
}

resource "aws_s3_object" "index_file" {
  key    = "index.html"
  bucket = aws_s3_bucket.main.id
  source = "${path.module}/index.html"
}

resource "aws_s3_object" "cer1_png" {
  key    = "cert1.png"
  bucket = aws_s3_bucket.main.id
  source = "${path.module}/cert1.png"
}

resource "aws_s3_object" "cer2_png" {
  key    = "cert2.png"
  bucket = aws_s3_bucket.main.id
  source = "${path.module}/cert2.png"
}

resource "aws_s3_object" "cer3_png" {
  key    = "cert3.png"
  bucket = aws_s3_bucket.main.id
  source = "${path.module}/cert3.png"
}

resource "aws_s3_object" "title_jpg" {
  key    = "paper.jpg"
  bucket = aws_s3_bucket.main.id
  source = "${path.module}/paper.jpg"
}