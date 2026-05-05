/*
  This page is used to create the load balancer for the RKE2 agents(worker nodes) 
  to control the traffic incoming into the node for both HTTP and HTTPS connections
*/

#create RKE2 load balancer 
resource "aws_lb" "rke2_ingress" {
  name               = substr(replace("${var.name_prefix}-ingress", "_", "-"), 0, 32)
  internal           = false
  load_balancer_type = "network"
  subnets            = values(aws_subnet.public)[*].id

  tags = {
    Name = "${var.name_prefix}-ingress"
  }
}

#where load balancer sends traffic
resource "aws_lb_target_group" "http" {
  name        = substr(replace("${var.name_prefix}-http", "_", "-"), 0, 32)
  port        = 80
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = aws_vpc.main.id

  health_check {
    protocol = "TCP"
    port     = "80"
  }
}

resource "aws_lb_target_group" "https" {
  name        = substr(replace("${var.name_prefix}-https", "_", "-"), 0, 32)
  port        = 443
  protocol    = "TCP"
  target_type = "instance"
  vpc_id      = aws_vpc.main.id

  health_check {
    protocol = "TCP"
    port     = "443"
  }
}

#the listener is what forwards the traffic from the lb to the target group 
resource "aws_lb_listener" "http" {
  load_balancer_arn = aws_lb.rke2_ingress.arn
  port              = "80"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.http.arn
  }
}

resource "aws_lb_listener" "https" {
  load_balancer_arn = aws_lb.rke2_ingress.arn
  port              = "443"
  protocol          = "TCP"

  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.https.arn
  }
}

#attaching the agent(worker nodes) to the lb target group 
resource "aws_lb_target_group_attachment" "http_agents" {
  count            = var.agent_count
  target_group_arn = aws_lb_target_group.http.arn
  target_id        = aws_instance.agent[count.index].id
  port             = 80
}

resource "aws_lb_target_group_attachment" "https_agents" {
  count            = var.agent_count
  target_group_arn = aws_lb_target_group.https.arn
  target_id        = aws_instance.agent[count.index].id
  port             = 443
}

