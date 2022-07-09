resource "aws_vpc" "test_vpc" {
  cidr_block       = var.vpc_cidr
  instance_tenancy = var.vpc_tenancy

  tags = {
    Name = "${var.project_name}-vpc-${var.account}-${var.env}"
  }
}

resource "aws_subnet" "test_subnet" {
  count             = length(var.subnet_cidrs)
  vpc_id            = aws_vpc.test_vpc.id
  cidr_block        = element(var.subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)

  tags = {
    Name = "${var.project_name}-public-subnet-${var.account}-${var.env}-${count.index + 1}"
  }
}

resource "aws_internet_gateway" "igw" {
  vpc_id = aws_vpc.test_vpc.id

  tags = {
    Name = "${var.project_name}-igw-${var.account}-${var.env}"
  }
}

resource "aws_route_table" "rt" {
  vpc_id = aws_vpc.test_vpc.id

  route {
    cidr_block = "0.0.0.0/0"
    gateway_id = aws_internet_gateway.igw.id
  }
  tags = {
    Name = "${var.project_name}-public-rt-${var.account}-${var.env}"
  }
}

resource "aws_route_table_association" "a" {
  count          = length(var.subnet_cidrs)
  subnet_id      = element(aws_subnet.test_subnet.*.id, count.index)
  route_table_id = aws_route_table.rt.id
}
