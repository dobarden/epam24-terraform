output "Nginx_public_ip" {
  description = "Public IP address of the EC2 Nginx Server"
  value       = aws_instance.ec2-task02.public_ip
}

output "RDS_Endpoint" {
  description = "Endpoint of the RDS"
  value       = aws_db_instance.my-db.endpoint
}

output "RDS_Username" {
  description = "RDS username"
  value       = aws_db_instance.my-db.username
}