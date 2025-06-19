variable "availability_zones" {
  description = "List of availability zones to use for the VPC"
  type        = list(string)
  default     = ["us-west-2a", "us-west-2b", "us-west-2c"]
  
}
variable "aws_vpc" {
    type = string
    default = "aws_vpc.main.id"
  
}
variable "public_cidr_block" {
  description = "CIDR block for the public subnet"
  type        = list(string) # requires the list type to allow multiple CIDR blocks
  default     = ["10.0.1.0/24", "10.0.3.0/24"]
  
}
variable "private_cidr_block" {
  description = "CIDR block for the private subnet"
  type        = list(string)
  default     = ["10.0.2.0/24", "10.0.4.0/24"]
}