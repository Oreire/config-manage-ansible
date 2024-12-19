#Outputs of the EC2 Instances (web_nodes)

/* output "web_server_public_dns" {
  value = aws_instance.web_nodes[*].public_dns
}
 */
output "web_nodes_ips" {
  value = aws_instance.web_nodes.*.public_ip
}

