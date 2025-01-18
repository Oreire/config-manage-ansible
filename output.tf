#Outputs of the EC2 Instances (web and app nodes)
output "web_nodes_ips" {
  value = aws_instance.web.*.public_ip
}

output "app_nodes_ips" {
  value = aws_instance.app.*.public_ip
}
