output "public_ip" {
  value       = aws_eip.my_static_ip.public_ip
  description = "this is instance public ip"
}


output "sg_id" {
  value       = aws_security_group.web-sg.id
  description = "this is security group id"
}
