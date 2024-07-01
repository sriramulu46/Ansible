#Creating S3 Bucket For Remote State.
#Commented as bucket is removed from statefile before destroy.
resource "aws_s3_bucket" "devsecopsb39tfstate" {
  bucket = "devsecopsb39tfstatefile"

  tags = {
    Name        = "devsecopsb39tfstatefile"
    Environment = var.environment
  }
}