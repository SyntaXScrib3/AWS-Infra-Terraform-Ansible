variable "aws_region" {
  type        = string
  description = "The AWS region to deploy resources"
  default     = "eu-central-1"
}

variable "alerts_email" {
  type        = string
  description = "Email address for alerts"
}

variable "ami_id" {
  description = "AMI ID for the EC2 instance"
  type        = string
  default     = "ami-07eef52105e8a2059"
}
