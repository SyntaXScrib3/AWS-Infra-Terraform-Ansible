# DevOps Project Documentation

## 1. Introduction

Welcome to the **DevOps Project** for building, configuring, and monitoring an AWS-based service. This project demonstrates how to:

1. **Provision AWS infrastructure** using **Terraform** (custom VPC, subnets, security groups, EC2 instances).
2. **Configure servers** with **Ansible** (installing Nginx, Redis, and a Flask application).
3. **Automate** the entire process using **GitLab CI/CD** pipelines.
4. **Monitor** and **alert** using **AWS CloudWatch** and **SNS** (email or Teams integration).

**Key Requirements**:

- No usage of the default VPC or Elastic IPs
- No ECS/EKS (we deploy the service directly on EC2)
- Terraform & Ansible must be invoked via GitLab pipeline
- Monitoring & alerting must be set up for the application/service

---

## 2. Project Structure

```
.
├── ansible/
│   ├── ansible.cfg
│   ├── inventory/
│   │   └── aws_ec2.yml
│   ├── group_vars/
│   │   └── all.yml
│   ├── roles/
│   │   ├── common/
│   │   │   └── tasks/
│   │   ├── flaskapp/
│   │   │   ├── tasks/
│   │   │   └── templates/
│   │   ├── nginx/
│   │   │   ├── tasks/
│   │   │   ├── templates/
│   │   │   └── handlers/
│   │   └── redis/
│   │       └── tasks/
│   └── playbook.yml
├── terraform/
│   ├── data-sources.tf
│   ├── alb.tf
│   ├── monitoring.tf
│   ├── variables.tf
│   ├── outputs.tf
│   └── main.tf
├── .gitlab-ci.yml
├── README.md        (this file)
└── .gitignore
```

---

## 3. Prerequisites

1. **AWS Account** with permissions to create VPCs, EC2 instances, SNS topics, etc.
2. **GitLab** project (with runners) that can execute the pipeline.
3. **Terraform** and **Ansible** installed locally if you plan to run them manually (optional if fully relying on GitLab runners).
4. **SSH Key Pair**: Terraform can generate one automatically or use your own existing pair.

---

## 4. Workflow Overview

1. **Infrastructure as Code (Terraform)**

   - We define a custom VPC with public subnets, an Internet gateway, route tables, and a security group.
   - We spin up one or more EC2 instances **without** Elastic IPs—only ephemeral public IP addresses.
   - We optionally create CloudWatch alarms and SNS topics for monitoring.

2. **Configuration Management (Ansible)**

   - We install required software on the EC2 instance(s):
     - **Redis**
     - **Nginx**
     - **Flask** (and Python dependencies)
   - We configure **Nginx** to reverse proxy to the Flask app on port 80.
   - We optionally set up environment variables and systemd services to keep the app running.

3. **Continuous Integration/Deployment (GitLab)**

   - **Build**: Prepare the environment.
   - **Validate**: Checks Terraform syntax and formatting.
   - **Plan**: Shows changes that will be applied.
   - **Apply**: Provisions or updates AWS resources.
   - **Configure**: Runs the Ansible playbook to install and configure software on the new EC2 instance.
   - **Destroy**: Tear down all Terraform-managed resources.

4. **Monitoring & Alerting (CloudWatch & SNS)**

   - Basic EC2 metrics (CPU, networking) are automatically collected by CloudWatch.
   - We set up alarms for high CPU usage or failing status checks.
   - Alerts are sent via SNS to either an **email** or (optionally) a **Teams** webhook.

---

### Appendix: References

- [Terraform Docs](https://developer.hashicorp.com/terraform/docs)
- [Ansible Docs](https://docs.ansible.com/)
- [GitLab CI/CD Docs](https://docs.gitlab.com/ee/ci/)
- [AWS CloudWatch](https://docs.aws.amazon.com/cloudwatch/)
