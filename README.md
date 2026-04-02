# 🚀 Terraform 6-Day Learning Plan — File Structure

## 📁 Directory Structure

```
terraform-6day/
├── .github/
│   └── workflows/
│       ├── terraform.yml           # Main CI/CD (single day)
│       ├── terraform-matrix.yml    # Multi-day parallel CI/CD
│       └── terraform-destroy.yml  # Manual destroy only
│
├── day1/   ← Foundations: EC2 + VPC (basics)
│   ├── providers.tf
│   ├── variables.tf
│   ├── vpc.tf
│   ├── security_group.tf
│   ├── ec2.tf
│   └── outputs.tf
│
├── day2/   ← Variables, Outputs & Remote State
│   ├── providers.tf        (backend commented — enable after apply)
│   ├── variables.tf
│   ├── locals.tf
│   ├── s3_backend.tf       (S3 bucket + DynamoDB lock)
│   └── outputs.tf
│
├── day3/   ← AWS Services: VPC + ALB + RDS
│   ├── providers.tf
│   ├── variables.tf
│   ├── vpc.tf              (public + private subnets, NAT gateway)
│   ├── alb.tf              (Application Load Balancer)
│   ├── rds.tf              (MySQL in private subnet)
│   └── outputs.tf
│
├── day4/   ← IAM + Lambda + ECS/Fargate
│   ├── providers.tf
│   ├── variables.tf
│   ├── iam.tf              (roles for Lambda + ECS)
│   ├── lambda.tf           (Python Lambda function)
│   ├── ecs.tf              (ECR + ECS Fargate)
│   └── outputs.tf
│
├── day5/   ← Workspaces + Auto Scaling
│   ├── providers.tf
│   ├── variables.tf        (workspace-aware sizing)
│   ├── vpc.tf
│   ├── asg.tf              (Launch Template + ASG + CloudWatch alarm)
│   └── outputs.tf
│
└── day6/   ← Production: S3 + CloudWatch + Billing Alarm
    ├── providers.tf
    ├── variables.tf
    ├── s3.tf               (versioning + encryption + lifecycle)
    ├── cloudwatch.tf       (dashboard + SNS + billing alarm)
    └── outputs.tf
```

---

## ⚡ Har Din Kaise Run Karein

### Step 1 — Prerequisites
```bash
# Terraform install verify karo
terraform version

# AWS credentials configure karo
aws configure
# AWS Access Key ID: xxxxxxxx
# AWS Secret Access Key: xxxxxxxx
# Default region: us-east-1
```

### Step 2 — Day wise run karo
```bash
# Example: Day 1 run karna
cd day1

terraform init      # providers download hote hain
terraform fmt       # code format hota hai
terraform validate  # syntax check
terraform plan      # kya banega — preview
terraform apply     # actually banao (yes type karo)
terraform destroy   # sab delete karo (jab sikh lo)
```

### Day 2 Special — Remote State Setup
```bash
cd day2

# Pehle S3 bucket banao (backend.tf me bucket naam update karo)
terraform init
terraform apply

# Phir providers.tf mein backend block uncomment karo
# Phir dobara:
terraform init  # State migrate hogi S3 mein
```

### Day 5 — Workspaces
```bash
cd day5

terraform workspace new dev      # dev workspace banao
terraform workspace new prod     # prod workspace banao
terraform workspace select dev   # dev select karo
terraform apply                  # dev config se deploy
terraform workspace select prod
terraform apply                  # prod config se (bada instance)
```

---

## 🔐 GitHub Secrets Setup

GitHub repo mein ye secrets add karo:
**Settings → Secrets and variables → Actions → New repository secret**

| Secret Name            | Value                              |
|------------------------|------------------------------------|
| `AWS_ACCESS_KEY_ID`    | IAM user ka access key             |
| `AWS_SECRET_ACCESS_KEY`| IAM user ka secret key             |
| `DB_PASSWORD`          | RDS ke liye password (day3+)       |

---

## 🔄 GitHub Actions — Workflow Kaise Kaam Karta Hai

```
Developer → git push (PR) → GitHub Actions trigger hota hai
                                       │
                          ┌────────────▼────────────┐
                          │   1. validate job        │
                          │   terraform fmt -check   │
                          │   terraform validate     │
                          └────────────┬────────────┘
                                       │
                     ┌─────────────────┴───────────────────┐
                     │                                     │
          ┌──────────▼──────────┐             ┌───────────▼──────────┐
          │  PR open?           │             │  Push to main?        │
          │  2. plan job        │             │  3. apply job         │
          │  terraform plan     │             │  terraform apply      │
          │  Comment on PR ✍️   │             │  Auto deploy 🚀       │
          └─────────────────────┘             └──────────────────────┘
```

### Workflow Files ka Use:
- **terraform.yml** → Ek specific day deploy karna ho
- **terraform-matrix.yml** → Automatically detect karta hai ki kaunsi day change hui, sirf wahi deploy karta hai
- **terraform-destroy.yml** → Manually trigger karo GitHub UI se, "DESTROY" type karo confirm ke liye

---

## ⚠️ Important Rules

1. **State file kabhi manually edit mat karo** — `terraform.tfstate`
2. **Secrets kabhi .tf files mein hardcode mat karo** — `TF_VAR_*` env vars use karo
3. **`terraform destroy` se pehle soch lo** — prod mein data delete ho jayega
4. **S3 backend day2 ke baad zaroor enable karo** — local state risky hai
5. **`sensitive = true`** sensitive outputs pe lagao (passwords, endpoints)

---

## 💡 Terraform Commands Cheatsheet

```bash
terraform init              # Initialize (pehli baar)
terraform init -upgrade     # Providers upgrade karo
terraform fmt               # Code auto-format
terraform fmt -check        # Format check (CI mein use)
terraform validate          # Syntax validate
terraform plan              # Preview changes
terraform plan -out=p.tfplan  # Plan save karo file mein
terraform apply             # Changes apply karo
terraform apply p.tfplan    # Saved plan apply karo
terraform destroy           # Sab delete karo
terraform state list        # State mein kya hai dekho
terraform state show <res>  # Ek resource ki details
terraform output            # Outputs dekho
terraform console           # Interactive REPL
terraform workspace list    # Workspaces list
terraform workspace new X   # Naya workspace
terraform workspace select X # Workspace switch
```
