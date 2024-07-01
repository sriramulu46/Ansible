
resource "aws_subnet" "public-subnets" {
  count             = length(var.public_subnet_cidrs)
  vpc_id            = aws_vpc.default.id
  cidr_block        = element(local.public_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)
  tags = {
    Name              = "${var.vpc_name}-Public-subnet-${count.index + 1}"
    Terraform-Managed = "Yes"
  }

}

resource "aws_subnet" "private-subnets" {
  count             = length(var.private_subnet_cidrs)
  vpc_id            = aws_vpc.default.id
  cidr_block        = element(local.private_subnet_cidrs, count.index)
  availability_zone = element(var.azs, count.index)
  tags = {
    Name              = "${var.vpc_name}-Private-subnet${count.index + 1}"
    Terraform-Managed = "Yes"
  }

}