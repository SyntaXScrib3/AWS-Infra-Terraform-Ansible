terraform {
  backend "s3" {
    bucket = "s3-ec1-terraform-state-bucket"
    key    = "terraform.tfstate"
    region = "eu-central-1"
  }

  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 5.0"
    }
  }
}

provider "aws" {
  region = var.aws_region
}


# ====================
# --- EC2 Instance ---
# ====================
resource "aws_instance" "devinfra_worker" {
  ami                    = var.ami_id
  instance_type          = "t2.micro"
  subnet_id              = data.aws_subnet.private_1a.id
  vpc_security_group_ids = [data.aws_security_group.ec1_lab.id]
  key_name               = data.aws_key_pair.devinfra.key_name

  tags = {
    Name = "ec2-ec1-1a-devinfra-worker"
  }
}



# ======================
# --- Route53 Record ---
# ======================
# Create a Route53 A record that points
# to the ALB's DNS name for 'devio.devops-ninja.me'
resource "aws_route53_record" "alb_dns" {
  zone_id = data.aws_route53_zone.existing_zone.zone_id
  name    = "devio.devops-ninja.me"
  type    = "A"

  alias {
    name                   = aws_lb.devinfra.dns_name
    zone_id                = aws_lb.devinfra.zone_id
    evaluate_target_health = true
  }
}
