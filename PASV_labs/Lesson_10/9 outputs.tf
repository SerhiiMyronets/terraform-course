# output "vpc_id" {
#   value = data.aws_vpc.defaul.id
# }
# output "subnets_list" {
#   value = data.aws_subnets.default.ids
# }
# output "availability_zone_list" {
#   value = toset(data.aws_subnets.default.id)
# }
output "load_balancer_dns" {
  value = aws_lb.web_lb.dns_name
}
