output "igw_id" {
  value = aws_internet_gateway.gw.id
  description = "The id of the internet gateway"
}

output "igw_arn" {
  value = aws_internet_gateway.gw.arn
  description = "The arn of the internet gateway"
}
