# Public Subnets
resource "aws_subnet" "public" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.public_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  map_public_ip_on_launch = true
  
  tags = {
    Name = "${var.environment}-public-subnet-${count.index + 1}"
  }
}

# App Private Subnets
resource "aws_subnet" "app_private" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.app_private_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  
  tags = {
    Name = "${var.environment}-app-private-subnet-${count.index + 1}"
  }
}

# DB Private Subnets
resource "aws_subnet" "db_private" {
  count                   = length(var.availability_zones)
  vpc_id                  = aws_vpc.main.id
  cidr_block              = var.db_private_subnets[count.index]
  availability_zone       = var.availability_zones[count.index]
  
  tags = {
    Name = "${var.environment}-db-private-subnet-${count.index + 1}"
  }
}