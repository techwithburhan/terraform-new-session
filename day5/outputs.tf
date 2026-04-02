output "workspace" {
  value = terraform.workspace
}

output "instance_type_used" {
  value = local.config.instance_type
}

output "asg_name" {
  value = aws_autoscaling_group.app.name
}

output "vpc_id" {
  value = aws_vpc.main.id
}
