resource "aws_s3_bucket" "salmanbkt" {
   bucket = "salman-test-proj"
   acl = "private"
   aws_s3_bucket_versioning {
      enabled = true
   }
   tags = {
     Name = "dev"
     Environment = "dev"
   }
}
