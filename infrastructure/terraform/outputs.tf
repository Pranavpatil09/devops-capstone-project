output "vpc_id" {
  description = "The ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_ids" {
  description = "List of public subnet IDs"
  value       = [aws_subnet.public_1.id, aws_subnet.public_2.id]
}

output "app_url" {
  description = "The URL to access the deployed application"
  value       = "http://${aws_lb.jenkins_alb.dns_name}"
}

output "jenkins_url" {
  description = "The URL to access Jenkins"
  value       = "http://${aws_instance.jenkins_server.public_ip}:8080"
}
