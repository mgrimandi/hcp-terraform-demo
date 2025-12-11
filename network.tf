resource "aws_vpc" "tf_vpc" {
  cidr_block = var.tf_vpc__cidr_block
  enable_dns_support = true
  enable_dns_hostnames = true
  tags = {
    Name = "${var.name_prefix}-vpc"
  }
}

# Internet Gateway (for Public Subnet)
resource "aws_internet_gateway" "tf_igw" {
  vpc_id = aws_vpc.tf_vpc.id

  tags = {
    Name = "${var.name_prefix}-igw"
  }
}

# Public Subnet
resource "aws_subnet" "tf_pub_subnet" {
  vpc_id                  = aws_vpc.tf_vpc.id
  cidr_block              = var.tf_pub_subnet__cidr_block
  # availability_zone       = "" # Or choose another AZ
  map_public_ip_on_launch = true 

  tags = {
    Name = "${var.name_prefix}-public-subnet"
  }
}

# Route Table for the Public Subnet
resource "aws_route_table" "tf_rt_public" {
  vpc_id = aws_vpc.tf_vpc.id

  # Route to the internet via the Internet Gateway
  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.tf_igw.id
  }

  tags = {
    Name = "${var.name_prefix}-public-rt"
  }
}

#  Associate the Public Route Table with the Public Subnet
resource "aws_route_table_association" "public" {
  subnet_id      = aws_subnet.tf_pub_subnet.id
  route_table_id = aws_route_table.tf_rt_public.id
}