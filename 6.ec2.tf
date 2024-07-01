resource "aws_instance" "webservers" {
  count                       = 3
  ami                         = var.imagename
  instance_type               = var.instance_type
  key_name                    = var.key_name
  subnet_id                   = element(aws_subnet.public-subnets.*.id, count.index)
  vpc_security_group_ids      = ["${aws_security_group.allow_all.id}"]
  associate_public_ip_address = true

  tags = {
    Name      = "${var.vpc_name}-Public-Server-${count.index + 1}"
    Env       = var.environment
    Owner     = var.owner
    ManagedBy = "Terraform"
  }

  root_block_device {
    volume_size           = "8"
    volume_type           = "gp2"
    encrypted             = true
    delete_on_termination = true
  }

  user_data = <<-EOF
    #!/bin/bash
    sudo apt-get update
    sudo apt-get install -y nginx
    sudo systemctl start nginx
    sudo systemctl enable nginx
    echo "<h1>Deployed via Terraform</h1>" | sudo tee -a /var/www/html/index.nginx-debian.html
    echo "<h1>${var.vpc_name}-Public-Server-${count.index}</h1>" | sudo tee -a /var/www/html/index.nginx-debian.html
    EOF

}