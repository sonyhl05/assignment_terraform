variable "region" {
  description = "AWS region"
  type        = string
  default     = "ap-south-1"
}
variable "instance_type" {
  description = "Type of EC2 instance"
  type        = string
  default     = "t2.micro"
}
