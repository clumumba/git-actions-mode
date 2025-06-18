
resource "aws_vpc" "main" {
  cidr_block       = "10.0.0.0/16"
  instance_tenancy = "default"
  enable_dns_support = true
  enable_dns_hostnames = true

  tags = {
    Name = "main"
  }
}

resource "aws_subnet" "public" {
  vpc_id            = var.aws_vpc
  cidr_block        = element(var.public_cidr_block, count.index) # Use the first public CIDR block from the variable
  count             = 2
  availability_zone = element(var.availability_zones, count.index) # Use the first availability zone from the variable  
  map_public_ip_on_launch = true

  tags = {
    Name = "public"
  }
}

resource "aws_subnet" "private" {
  vpc_id            = var.aws_vpc
  cidr_block        = element(var.private_cidr_block, count.index) # Use the first private CIDR block from the variable
  count             = 2 # Ensure only the number of private subnet you want is created
  availability_zone = element(var.availability_zones, count.index) # Use the second availability zone from the variable
  map_public_ip_on_launch = false  


  tags = {
    Name = "private"
  } 
}

#internet gatway for the public subnet
resource "aws_internet_gateway" "main" {
  vpc_id = var.aws_vpc

  tags = {
    Name = "main"
  }
}
resource "aws_nat_gateway" "main_nat" {
  allocation_id = aws_eip.main_nat.id
  subnet_id     = aws_subnet.public.id

  tags = {
    Name = "main_nat"
  }
  
}
resource "aws_eip" "main_eip" {

  tags = {
    Name = "main_nat"
  }
}
resource "aws_route_table" "public" {
  vpc_id = var.aws_vpc

  route {
    cidr_block = "0.0.0/0"
    gateway_id = aws_internet_gateway.main.id 
  }
  tags = {
    Name = "public"
  }
}
resource "aws_route_table" "private" {
  vpc_id = var.aws_vpc

  tags = {
    Name = "private"
  }
} 

resource "aws_route" "private" {
  route_table_id         = aws_route_table.private.id
  destination_cidr_block = "0.0.0.0/0"
  nat_gateway_id         = aws_nat_gateway.main_nat.id
}

resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.public[*].id[count.index]
  route_table_id = aws_route_table.public.id
  count          = length(aws_subnet.public[*].id)      
  
}

resource "aws_route_table_association" "private" {
  subnet_id      = aws_subnet.private[*].id[count.index]
  route_table_id = aws_route_table.private.id
  count          = length(aws_subnet.private[*].id)      
}