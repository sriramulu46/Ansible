resource "aws_route_table" "terraform-public" {
  vpc_id = aws_vpc.default.id
  # route {
  #   cidr_block = "0.0.0.0/0"
  #   gateway_id = aws_internet_gateway.default.id
  # }
  tags = {
    Name = "${var.vpc_name}-Public-RT"
  }

}

resource "aws_route_table" "terraform-private" {
  vpc_id = aws_vpc.default.id

  tags = {
    Name              = "${var.vpc_name}-Private-RT"
    Terraform-Managed = "Yes"
    Env               = local.new_environment
    ProjectID         = local.projid
  }
}

resource "aws_route" "igw-route" {
  route_table_id         = aws_route_table.terraform-public.id
  destination_cidr_block = "0.0.0.0/0"
  gateway_id             = aws_internet_gateway.default.id
}


# resource "aws_route_table" "terraform-private" {
#   vpc_id = aws_vpc.default.id

#   tags = {
#     Name = "${var.vpc_name}-Private-RT"
#   }


# }

resource "aws_route_table_association" "terraform-public" {
  count          = length(var.public_subnet_cidrs)
  subnet_id      = element(aws_subnet.public-subnets.*.id, count.index)
  route_table_id = aws_route_table.terraform-public.id
}

resource "aws_route_table_association" "terraform-private" {
  count          = length(var.private_subnet_cidrs)
  subnet_id      = element(aws_subnet.private-subnets.*.id, count.index)
  route_table_id = aws_route_table.terraform-private.id

}

