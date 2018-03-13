variable "vpc_cidr" {
  description = "CIDR for the whole VPC"
  default     = "10.1.0.0/16"
}

provider "aws" {
  region = "us-east-1"
}

variable "public_subnet_cidr" {
  description = "CIDR for the Public Subnet"
  default     = "10.1.0.0/24"
}

variable "private_subnet_cidr" {
  description = "CIDR for the Private Subnet"
  default     = "10.1.1.0/24"
}

variable "zones" {
  default = ["us-east-1a", "us-east-1b", "us-east-1c", "us-east-1d", "us-east-1e", "us-east-1f"]
}

terraform {
  backend "s3" {
    bucket = "chlmes.terraform"
    key    = "tf_state/bootstrap"
    region = "us-east-1"
  }
}
