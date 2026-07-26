# Remote state backend (S3 + DynamoDB for state locking).
# Fill in a real bucket/table and uncomment to use. Backend config
# does NOT accept variables, so values must be hardcoded here or
# passed via `terraform init -backend-config=...`.

# terraform {
#   backend "s3" {
#     bucket         = "my-terraform-state-bucket"
#     key            = "aws-vpc/terraform.tfstate"
#     region         = "us-east-1"
#     dynamodb_table = "terraform-lock-table"
#     encrypt        = true
#   }
# }
