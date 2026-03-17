variable "aws_region" {
  description = "AWS region for all resources."
  type        = string
  default     = "eu-west-3"
}

variable "ami_id" {
  description = "AMI ID used for EC2 instances in server subnets."
  type        = string
}

variable "instance_type" {
  description = "EC2 instance type for server nodes."
  type        = string
  default     = "t3.micro"
}

variable "app_image" {
  description = "Full ECR image URL used by app containers."
  type        = string
}

variable "nginx_image" {
  description = "Full ECR image URL used by nginx container."
  type        = string
}
