resource "local_file" "ansible_inventory" {
  filename = "${path.module}/../ansible/inventory.ini"
  content = templatefile("${path.module}/inventory.tftpl", {
    server = [for i in aws_instance.server : {
      name       = i.tags.Name
      public_ip  = i.public_ip
      private_ip = i.private_ip
    }]
    agent = [for i in aws_instance.agent : {
      name       = i.tags.Name
      public_ip  = i.public_ip
      private_ip = i.private_ip
    }]
  })
}

resource "local_file" "nlb_dns_name" {
  filename = "${path.module}/nlb_dns_name.txt"
  content  = aws_lb.rke2_ingress.dns_name
}

resource "local_file" "kube_api_endpoint" {
  filename = "${path.module}/kube_api_endpoint.txt"
  content  = "https://${aws_instance.server[0].public_ip}:6443"
}
