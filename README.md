# 🔄 CI/CD Pipeline with Jenkins

## 🎯 الهدف

تم إعداد المشروع ليعمل مع **Jenkins Pipeline** بحيث يمكن نشر البنية التحتية (Infrastructure) على AWS باستخدام Terraform مع اختيار بيئة التشغيل (Environment) أثناء تنفيذ الـ Pipeline.

---

## 📂 Project Structure

```
terraform-Day2/
│
├── Jenkinsfile
├── provider.tf
├── backend.tf
├── variables.tf
├── outputs.tf
├── main.tf
│
├── dev.tfvars
├── stag.tfvars
├── prod.tfvars
│
└── modules/
    ├── networking/
    ├── security/
    ├── alb/
    └── compute/
```

---

## Jenkins Pipeline Flow

```
GitHub Repository
        │
        ▼
Jenkins Pipeline
        │
        ▼
Checkout Source Code
        │
        ▼
Terraform Init
        │
        ▼
Terraform Format
        │
        ▼
Terraform Validate
        │
        ▼
Terraform Plan
        │
        ▼
Manual Approval
        │
        ▼
Terraform Apply
        │
        ▼
Terraform Outputs
```

---

## ⚙️ Build Parameters

The Jenkins Pipeline uses a **Choice Parameter** called:

```
ENVIRONMENT
```

Available values:

```
dev
stag
prod
```

According to the selected environment, Jenkins automatically executes Terraform using:

| Environment | Vars File     | Backend State Key         | Instance Type |
|-------------|---------------|---------------------------|---------------|
| dev         | dev.tfvars    | dev/terraform.tfstate     | t3.micro      |
| stag        | stag.tfvars   | stag/terraform.tfstate    | t3.small      |
| prod        | prod.tfvars   | prod/terraform.tfstate    | t3.medium     |

No code modification is required when switching environments.

---

## 🔧 Jenkins Setup

### Prerequisites

1. **Jenkins Plugins Required:**
   - Pipeline
   - Git
   - AWS Credentials Plugin

2. **Jenkins Credentials:**
   - Add an AWS credential with ID `aws-credentials` (Access Key + Secret Key)

3. **Tools on Jenkins Agent:**
   - `terraform` >= 1.5.0 must be installed and in `$PATH`
   - `git` must be installed

### Creating the Pipeline Job

1. New Item → **Pipeline**
2. Under **Pipeline Definition** → Pipeline script from SCM
3. SCM: `Git` → enter your GitHub repository URL
4. Script Path: `Jenkinsfile`
5. Save and click **Build with Parameters**

---

## 🚀 Terraform Commands Executed

```bash
# Stage 2 – Init (with per-environment backend key)
terraform init -reconfigure \
    -backend-config="key=<environment>/terraform.tfstate"

# Stage 3 – Format Check
terraform fmt -check -recursive

# Stage 4 – Validate
terraform validate

# Stage 5 – Plan
terraform plan \
    -var-file=<environment>.tfvars \
    -out=tfplan

# Stage 7 – Apply (after manual approval)
terraform apply tfplan

# Stage 8 – Outputs
terraform output
```

---

## 🗂️ S3 Backend

State files are stored per environment in the same S3 bucket:

```
s3://terraform-state-mohamed-2026/
├── dev/terraform.tfstate
├── stag/terraform.tfstate
└── prod/terraform.tfstate
```

---

## ✅ Advantages

| Feature                         | Details                               |
|---------------------------------|---------------------------------------|
| Modular Terraform Architecture  | Reusable modules under modules/       |
| Infrastructure as Code (IaC)    | All infra defined in Terraform        |
| Environment Separation          | Isolated state and configs per env    |
| CI/CD Ready                     | Fully automated Jenkins pipeline      |
| GitHub Integration              | Trigger on push / branch              |
| Jenkins Automation              | No manual CLI commands needed         |
| Easy Multi-Env Deployment       | One click — select Dev / Stage / Prod |

---

## 🛠️ Technologies Used

| Technology              | Purpose                         |
|-------------------------|---------------------------------|
| Terraform               | Infrastructure as Code          |
| AWS                     | Cloud Provider                  |
| Jenkins                 | CI/CD Automation                |
| GitHub                  | Source Control                  |
| EC2                     | Virtual Machines                |
| Auto Scaling Group      | Dynamic scaling                 |
| Application Load Balancer | HTTP traffic distribution     |
| VPC                     | Network isolation               |
| NAT Gateway             | Private subnet internet access  |
| Internet Gateway        | Public subnet internet access   |
| Route Tables            | Network routing                 |
| Security Groups         | Firewall rules                  |
| S3 Backend              | Remote Terraform state storage  |

---

## 👤 Author

**Mohamed** — NTI DevOps Track
# Pipeline-IaC
