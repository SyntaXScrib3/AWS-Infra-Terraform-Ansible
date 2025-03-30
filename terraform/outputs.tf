# Output the instance’s private IP for reference
output "ec2_private_ip" {
  description = "Private IP address of the EC2 instance"
  value       = aws_instance.devinfra_worker.private_ip
}
