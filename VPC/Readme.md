 Terraform VPC setup. 
 ---

```markdown
# 🌐 AWS VPC Setup with Public & Private Subnets

This Terraform configuration provisions a custom AWS Virtual Private Cloud (VPC) with public and private subnets, internet and NAT gateways, and routing logic to enable secure and scalable networking.

## 🚀 Features

- Custom VPC using [terraform-aws-modules/vpc](https://registry.terraform.io/modules/terraform-aws-modules/vpc/aws)
- 4 Subnets:
  - 2 Public: `10.0.1.0/24`, `10.0.2.0/24`
  - 2 Private: `10.0.3.0/24`, `10.0.4.0/24`
- Internet Gateway for public access
- NAT Gateway for outbound internet access from private subnets
- Route tables and associations for proper traffic flow
- Dynamic lookup of default route table for NAT routing

## 📦 Module Used

```hcl
module "vpc" {
  source  = "terraform-aws-modules/vpc/aws"
  version = "6.0.1"
}
```

## 🧱 Resources Created

| Resource Type              | Description                                 |
|---------------------------|---------------------------------------------|
| `aws_subnet`              | Creates 4 subnets with custom CIDRs         |
| `aws_internet_gateway`    | Enables internet access for public subnets  |
| `aws_nat_gateway`         | Provides outbound access for private subnets|
| `aws_route_table`         | Custom route table for public subnets       |
| `aws_route_table_association` | Associates public subnets to public RT |
| `aws_route`               | Adds default routes to IGW and NAT Gateway  |
| `aws_eip`                 | Elastic IP for NAT Gateway                  |
| `data.aws_route_tables`   | Fetches default route table for NAT routing |
| `output`                  | Displays default route table ID             |

## 🛠️ Usage

1. **Initialize Terraform**

   ```bash
   terraform init
   ```

2. **Plan the Deployment**

   ```bash
   terraform plan
   ```

3. **Apply the Configuration**

   ```bash
   terraform apply
   ```

## 🔐 Notes

- Ensure your AWS CLI profile `ACG` is configured correctly.
- NAT Gateway is placed in `subnet1` (`Public-1`) for outbound traffic.
- Default route table is dynamically queried to attach NAT route.

## 📤 Outputs

| Output Name | Description                     |
|-------------|---------------------------------|
| `rt_details`| Default route table ID for VPC  |

---
