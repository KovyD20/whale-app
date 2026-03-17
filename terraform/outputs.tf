output "alb_dns_name" {
  description = "Public DNS name of the application load balancer."
  value       = aws_lb.main.dns_name
}

output "app_ecr_repository_url" {
  description = "ECR repository URL for app image."
  value       = aws_ecr_repository.kd-whale_app.repository_url
}

output "nginx_ecr_repository_url" {
  description = "ECR repository URL for nginx image."
  value       = aws_ecr_repository.kd-whale_nginx.repository_url
}

output "server_instance_ids" {
  description = "EC2 instance IDs in private server subnets."
  value       = [for instance in aws_instance.server : instance.id]
}
