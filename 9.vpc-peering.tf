data "aws_vpc" "ansible_vpc" {
  id = "vpc-0bd6ce7dcbbfa3ce0"
}

data "aws_route_table" "ansible_vpc_rt" {
  vpc_id = var.vpc_id # Make sure this variable is correctly defined

  filter {
    name   = "tag:Name"
    values = ["ansible-vpc-rt"] # Adjust this tag as necessary
  }
}

resource "aws_vpc_peering_connection" "ansible-vpc-peering" {
  peer_vpc_id = data.aws_vpc.ansible_vpc.id
  vpc_id      = aws_vpc.default.id
  auto_accept = true
  accepter {
    allow_remote_vpc_dns_resolution = true
  }

  requester {
    allow_remote_vpc_dns_resolution = true
  }

  tags = {
    Name = "Ansible-${var.vpc_name}-Peering"
  }
}

resource "aws_route" "peering-to-ansible-vpc" {
  route_table_id         = aws_route_table.terraform-public.id
  destination_cidr_block = data.aws_vpc.ansible_vpc.cidr_block
  #"10.40.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.ansible-vpc-peering.id
  depends_on                = [aws_route_table.terraform-public]
}

resource "aws_route" "peering-from-ansible-vpc" {
  route_table_id         = data.aws_route_table.ansible_vpc_rt.id
  destination_cidr_block = aws_vpc.default.cidr_block
  #"10.38.0.0/16"
  vpc_peering_connection_id = aws_vpc_peering_connection.ansible-vpc-peering.id
  depends_on                = [aws_route_table.terraform-public]
}
