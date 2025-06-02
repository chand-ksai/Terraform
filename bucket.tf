provider "aws" {
  alias  = "account_a"
  region = "us-east-1"
  profile = "saimyaccount"
}

provider "aws" {
  alias  = "account_b"
  region = "us-east-1"
  profile = "saimyaccount"  # still using Account A credentials
 
   assume_role {
    role_arn     = "arn:aws:iam::654654587449:role/CrossAccountAccessRole"
    session_name = "TerraformCrossAccountSession"
  }
}

# Optional: Verify identity in Account A
data "aws_caller_identity" "account_a" {
  provider = aws.account_a
}

output "account_a_id" {
  value = data.aws_caller_identity.account_a.account_id
}


# Optional: Verify identity in Account B
data "aws_caller_identity" "account_b" {
  provider = aws.account_b
}

output "account_b_id" {
  value = data.aws_caller_identity.account_b.account_id
}


# Create an S3 bucket in Account B
resource "aws_s3_bucket" "bucket_in_b" {
  provider = aws.account_b
  bucket   = "my-cross-account-bucket-123456-kanikisettyqs"
 }
