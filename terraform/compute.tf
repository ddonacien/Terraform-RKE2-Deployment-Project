locals {
  server_names = [for i in range(var.server_count) : format("%s-server-%02d", var.name_prefix, i + 1)]
  agent_names  = [for i in range(var.agent_count) : format("%s-agent-%02d", var.name_prefix, i + 1)]
  server_ids   = values(aws_subnet.public)[*].id
}

resource "aws_instance" "server" {
  count                       = var.server_count
  ami                         = data.aws_ami.rhel-ami.id
  instance_type               = "t3.micro"
  subnet_id                   = local.server_ids[count.index % length(local.server_ids)]
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.cluster.id]

  root_block_device {
    volume_size           = var.volume_size
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name = local.server_names[count.index]
    Role = "server"
  }
}

resource "aws_instance" "agent" {
  count                       = var.server_count
  ami                         = data.aws_ami.rhel-ami.id
  instance_type               = "t3.micro"
  subnet_id                   = local.server_ids[count.index % length(local.server_ids)]
  associate_public_ip_address = true
  vpc_security_group_ids      = [aws_security_group.cluster.id]

  root_block_device {
    volume_size           = var.volume_size
    volume_type           = "gp3"
    delete_on_termination = true
  }

  tags = {
    Name = local.agent_names[count.index]
    Role = "agent"
  }

}

