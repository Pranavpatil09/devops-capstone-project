variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "CIDR block for the VPC"
  type        = string
  default     = "10.0.0.0/16"
}

variable "project" {
  description = "Project name"
  type        = string
  default     = "project"
}

variable "env" {
  description = "Environment name (e.g., dev, prod)"
  type        = string
  default     = "dev"
}

variable "public_subnet_1_cidr" {
  description = "CIDR block for Public Subnet 1"
  type        = string
  default     = "10.0.1.0/24"
}

variable "public_subnet_2_cidr" {
  description = "CIDR block for Public Subnet 2"
  type        = string
  default     = "10.0.2.0/24"
}

variable "public_subnet_1_az" {
  description = "Availability Zone for Public Subnet 1"
  type        = string
  default     = "ap-south-1a"
}

variable "public_subnet_2_az" {
  description = "Availability Zone for Public Subnet 2"
  type        = string
  default     = "ap-south-1b"
}

variable "private_subnet_1_cidr" {
  description = "CIDR block for Private Subnet 1"
  type        = string
  default     = "10.0.3.0/24"
}

variable "private_subnet_2_cidr" {
  description = "CIDR block for Private Subnet 2"
  type        = string
  default     = "10.0.4.0/24"
}

variable "private_subnet_1_az" {
  description = "Availability Zone for Private Subnet 1"
  type        = string
  default     = "ap-south-1a"
}

variable "private_subnet_2_az" {
  description = "Availability Zone for Private Subnet 2"
  type        = string
  default     = "ap-south-1b"
}
variable "admin_ip" {
  description = "Admin IP for SSH access (optional)"
  type        = string
  default     = "0.0.0.0/0" # Consider restricting this in production
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t3.micro"
}

variable "asg_min" {
  description = "Minimum size of the Auto Scaling Group"
  type        = number
  default     = 1
}

variable "asg_max" {
  description = "Maximum size of the Auto Scaling Group"
  type        = number
  default     = 3
}

variable "asg_desired" {
  description = "Desired capacity of the Auto Scaling Group"
  type        = number
  default     = 2
}

variable "key_name" {
  description = "Existing AWS key pair name"
  type        = string
  default     = "devops-key"
}
