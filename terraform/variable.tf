variable "region" {
  default = "ap-south-1"
}

variable "instance_type" {
  default = "t3.micro"
}

variable "ami" {
  default = "ami-0f5ee92e2d63afc18"
}

variable "key_name" {
  description = "Your existing AWS key pair name"
}
