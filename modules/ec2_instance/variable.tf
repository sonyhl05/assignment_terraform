variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}

variable "vpc_cidr" {
  description = "VPC CIDR Block"
  type        = string
  default     = "10.0.0.0/16"
}

variable "instance_type" {
  description = "EC2 instance type"
  type        = string
  default     = "t2.micro"
}

variable "workspace_cidrs" {
  description = "CIDR blocks for each workspace"
  type        = map(string)
  default = {
    dev   = "10.1.0.0/16"
    stage = "10.2.0.0/16"
    prod  = "10.3.0.0/16"
  }
}
