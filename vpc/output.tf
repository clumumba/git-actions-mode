output "vpc_id" {
  description = "The ID of the VPC created by this module."
  value       = aws_vpc.main.id
  
}
output "public_subnet_id" {
  description = "The ID of the public subnet created by this module."
  value       = aws_subnet.public.id
  
}
output "private_subnet_id" {
  description = "The ID of the private subnet created by this module."
  value       = aws_subnet.private.id
  
}