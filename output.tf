
output "web_server1_ips" {
  value = aws_instance.node1.public_ip
}

output "web_server2_ips" {
  value = aws_instance.node2.public_ip
}

