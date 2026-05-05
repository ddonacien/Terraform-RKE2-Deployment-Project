resource "aws_security_group" "cluster" {
  name        = "${var.name_prefix}-cluser-sg"
  description = "security group for clusters"
  vpc_id      = aws_vpc.main.id

  ingress {
    description = "SSH"
    protocol    = "tcp"
    from_port   = 22
    to_port     = 22
    cidr_blocks = var.ssh_allowed_cidrs
  }

  ingress {
    description = "KUBE API"
    protocol    = "tcp"
    from_port   = 6443
    to_port     = 6443
    cidr_blocks = var.ssh_allowed_cidrs
  }

  ingress {
    description = "RKE2 Port"
    protocol    = "tcp"
    from_port   = 9345
    to_port     = 9345
    self        = true
  }

  ingress {
    description = "All Traffic within cluster"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    self        = true
  }

  ingress {
    description = "HTTP LB"
    protocol    = "tcp"
    from_port   = 80
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "HTTPS LB"
    protocol    = "tcp"
    from_port   = 443
    to_port     = 443
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    description = "outgoing traffic"
    protocol    = "-1"
    from_port   = 0
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "${var.name_prefix}-cluster-sg"
  }
}
