variable "region" {
  default = "ap-south-1"
}

variable "ami" {
  description = "Amazon Linux 2 AMI for Mumbai"
  default     = "ami-0317b0f0a0144b137"
}

variable "key_name" {
  description = "Existing AWS key pair name"
  default     = "devops-key"
}
