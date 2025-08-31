Reusable Terraform modules for secure cross-account IAM roles in AWS.

---

```markdown
# 🔐 Cross-Account IAM Role Terraform Module

This Terraform module provisions secure, reusable IAM roles for cross-account access in AWS. It supports fine-grained permissions, external ID enforcement, and tagging for compliance visibility.

## 📦 Features

- Create IAM roles with trust policies for external AWS accounts
- Enforce external ID for added security
- Attach managed or inline policies
- Modular design for reuse across environments
- Supports tagging for audit and cost tracking

## 📁 Module Structure

```
modules/
└── cross-account-iam-role/
    ├── main.tf
    ├── variables.tf
    ├── outputs.tf
    └── README.md
```

## 🚀 Usage

```hcl
module "cross_account_role" {
  source              = "./modules/cross-account-iam-role"
  role_name           = "external-access-role"
  trusted_account_id  = "123456789012"
  external_id         = "secure-external-id"
  policy_arns         = ["arn:aws:iam::aws:policy/ReadOnlyAccess"]
  tags = {
    Environment = "dev"
    Owner       = "devops-team"
  }
}
```

## 🔒 Security Best Practices

- ✅ Use `external_id` to prevent confused deputy attacks
- ✅ Limit permissions with least privilege policies
- ✅ Enable CloudTrail for role usage auditing
- ✅ Rotate credentials and monitor access patterns

## 📤 Outputs

- `role_arn` – ARN of the created IAM role
- `role_name` – Name of the IAM role

## 📚 References

- [AWS Cross-Account Access](https://docs.aws.amazon.com/IAM/latest/UserGuide/id_roles_create_for-user.html)
- [Terraform IAM Docs](https://registry.terraform.io/providers/hashicorp/aws/latest/docs/resources/iam_role)

---
