terraform {
  required_providers {
    aws = {
        source = "hashicorp/aws"
        version = "~> 3.0"
    }
  }
}
provider "aws" {
    region = var.region
  
}
module "ec2_instance" {
  source        = "git::https://github.com/sonyhl05/assignment_terraform.git//modules/ec2_instance"
  region        = var.region
  instance_type = var.instance_type
}
