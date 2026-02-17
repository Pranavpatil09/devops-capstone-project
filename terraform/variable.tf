variable "region" {
  default = "ap-south-1"
}

variable "ami" {
  description = "Amazon Linux 2 AMI for Mumbai"
  default     = "ami-03f4878755434977f"
}

variable "key_name" {
  description = "Existing AWS key pair name"
  default     = "devops-key"
}
