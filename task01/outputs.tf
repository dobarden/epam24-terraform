output "AWS-VPCs" {
  value = data.aws_vpcs.vpc_ids.ids
}

output "AWS-subnets" {
  value = data.aws_subnets.subnet_ids.ids
}

output "AWS-security-groups" {
  value = data.aws_security_groups.sg_ids.ids
}

