
 
 provider "aws" {
  alias  = "account_a"
  region = "us-east-1"
  profile = "account-a-profile"  # or use access_key/secret_key
}

provider "aws" {
  alias  = "account_b"
  region = "us-east-1"
  profile = "account-b-profile"
}

# Create a resource in Account A
resource "aws_s3_bucket" "bucket_in_a" {
  provider = aws.account_a
  bucket   = "my-unique-bucket-in-account-a"
  acl      = "private"
}

# Assume a role in Account B from Account A
data "aws_caller_identity" "current" {
  provider = aws.account_a
}

data "aws_iam_role" "assume_role_in_b" {
  provider = aws.account_b
  name     = "RoleToAssumeFromA"
}

resource "aws_s3_bucket" "bucket_in_b" {
  provider = aws.account_b
  bucket   = "my-unique-bucket-in-account-b"
  acl      = "private"
}


**********
Make sure the IAM role in Account B allows Account A to assume it.
You can use assume_role in the provider block if needed for cross-account access.

*****************
To **assume a role in another AWS account** using Terraform, you need to configure the AWS provider with the `assume_role` block. This is commonly used in **cross-account setups**, where one AWS account (Account A) needs to access resources in another (Account B) by assuming a role that has been explicitly shared.

---

### ✅ Step-by-Step: Assume Role in Another AWS Account

#### 1. **In Account B (Target Account)**:
Create an IAM Role that Account A can assume.

```json
{
  "Version": "2012-10-17",
  "Statement": [
    {
      "Effect": "Allow",
      "Principal": {
        "AWS": "arn:aws:iam::<ACCOUNT_A_ID>:root"
      },
      "Action": "sts:AssumeRole"
    }
  ]
}
```

Attach this trust policy to a role (e.g., `CrossAccountAccessRole`) and assign necessary permissions.

---

#### 2. **In Terraform (Account A)**:
Use the `assume_role` block in the provider configuration.

```hcl
provider "aws" {
  alias  = "account_b"
  region = "us-east-1"

  assume_role {
    role_arn     = "arn:aws:iam::<ACCOUNT_B_ID>:role/CrossAccountAccessRole"
    session_name = "TerraformSession"
  }

  profile = "account-a-profile"  # or use access_key/secret_key
}
```

Now, any resource using `provider = aws.account_b` will be created in Account B using the assumed role.

---

### 🧪 Example Usage

```hcl
resource "aws_s3_bucket" "bucket_in_b" {
  provider = aws.account_b
  bucket   = "my-cross-account-bucket"
  acl      = "private"
}
```

---

Would you like a complete working example with both account configurations and a sample resource?

###################################
***********************************
Here’s a **complete Terraform example** that demonstrates how to:

- Use **Account A** to authenticate.
- **Assume a role in Account B**.
- Create an S3 bucket in **Account B** using the assumed role.

---

## 🧾 Assumptions

- **Account A** has a named AWS CLI profile: `account-a-profile`.
- **Account B** has a role named `CrossAccountAccessRole` that Account A is allowed to assume.
- The role in Account B has a trust policy allowing Account A to assume it.

---

## 📁 Terraform Project Structure

```
terraform-cross-account/
├── main.tf
├── variables.tf
└── outputs.tf
```

---

### 📄 `main.tf`

```hcl
provider "aws" {
  alias  = "account_a"
  region = "us-east-1"
  profile = "account-a-profile"
}

provider "aws" {
  alias  = "account_b"
  region = "us-east-1"
  profile = "account-a-profile"  # still using Account A credentials

  assume_role {
    role_arn     = "arn:aws:iam::<ACCOUNT_B_ID>:role/CrossAccountAccessRole"
    session_name = "TerraformCrossAccountSession"
  }
}

# Optional: Verify identity in Account A
data "aws_caller_identity" "account_a" {
  provider = aws.account_a
}

# Optional: Verify identity in Account B
data "aws_caller_identity" "account_b" {
  provider = aws.account_b
}

# Create an S3 bucket in Account B
resource "aws_s3_bucket" "bucket_in_b" {
  provider = aws.account_b
  bucket   = "my-cross-account-bucket-123456"
  acl      = "private"
}
```

---

### 📄 `variables.tf`

```hcl
variable "region" {
  default = "us-east-1"
}
```

---

### 📄 `outputs.tf`

```hcl
output "account_a_id" {
  value = data.aws_caller_identity.account_a.account_id
}

output "account_b_id" {
  value = data.aws_caller_identity.account_b.account_id
}

output "bucket_name" {
  value = aws_s3_bucket.bucket_in_b.bucket
}
```

---

### ✅ How to Use

1. Replace `<ACCOUNT_B_ID>` with the actual AWS Account ID of Account B.
2. Run the following commands:

```bash
terraform init
terraform plan
terraform apply
```

---

Would you like me to generate this as a downloadable `.zip` file or help you test it with a specific AWS service other than S3?


