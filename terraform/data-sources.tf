
# =====================
# --- VPC & Subnets ---
# =====================
# Retrieve the existing VPC by tag name.
# Other resources (like subnets, security groups) reference it.
data "aws_vpc" "ec1_lab" {
  filter {
    name   = "tag:Name"
    values = ["vpc-ec1-lab"]
  }
}

data "aws_subnet" "public_1a" {
  filter {
    name   = "tag:Name"
    values = ["sbn-ec1-1a-public1-lab"]
  }
}

data "aws_subnet" "public_1b" {
  filter {
    name   = "tag:Name"
    values = ["sbn-ec1-1b-public2-lab"]
  }
}

data "aws_subnet" "private_1a" {
  filter {
    name   = "tag:Name"
    values = ["sbn-ec1-1a-private1-lab"]
  }
}

# =======================
# --- Security Groups ---
# =======================
data "aws_security_group" "ec1_lab" {
  filter {
    name   = "tag:Name"
    values = ["sg-ec1-lab"]
  }
}

# =================
# --- Key Pairs ---
# =================
data "aws_key_pair" "devinfra" {
  filter {
    name   = "key-name"
    values = ["devinfra-key-pair"]
  }
}

# ========================
# --- ACM Certificates ---
# ========================
# Fetch the most recent matching ACM certificate.
# We reference this certificate in the HTTPS listener.
data "aws_acm_certificate" "devops_ninja" {
  domain      = "*.devops-ninja.me"
  statuses    = ["ISSUED"]
  most_recent = true
}

# ====================
# --- Route53 Zone ---
# ====================
data "aws_route53_zone" "existing_zone" {
  name         = "devio.devops-ninja.me"
  private_zone = false
}
