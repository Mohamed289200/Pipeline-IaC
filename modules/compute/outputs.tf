output "instance_id" {
  description = "ID of the standalone web server EC2 instance"
  value       = aws_instance.web_server.id
}

output "instance_public_ip" {
  description = "Public IP of the standalone web server EC2 instance"
  value       = aws_instance.web_server.public_ip
}

output "asg_name" {
  description = "Name of the Auto Scaling Group"
  value       = aws_autoscaling_group.web_asg.name
}

output "launch_template_id" {
  description = "ID of the Launch Template"
  value       = aws_launch_template.web_lt.id
}
