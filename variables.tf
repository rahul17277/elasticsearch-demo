variable "aws_region" {
  default     = "us-east-1"
}

variable "aws_access_key" {}

variable "aws_secret_key" {}

# Need to provide a Red-Hat based image
variable "aws_ami" {
  default = "ami-XXXXXX"
}

variable "aws_instance_type" {
  default     = "t2.micro"
}
