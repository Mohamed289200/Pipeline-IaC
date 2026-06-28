output "vpc_id" {
  description = "ID of the VPC"
  value       = aws_vpc.main.id
}

output "public_subnet_1" {
  description = "ID of public subnet 1"
  value       = aws_subnet.public1.id
}

output "public_subnet_2" {
  description = "ID of public subnet 2"
  value       = aws_subnet.public2.id
}

output "private_subnet_1" {
  description = "ID of private subnet 1"
  value       = aws_subnet.private1.id
}

output "private_subnet_2" {
  description = "ID of private subnet 2"
  value       = aws_subnet.private2.id
}

output "nat_gateway_id" {
  description = "ID of the NAT Gateway"
  value       = aws_nat_gateway.nat.id
}

output "internet_gateway_id" {
  description = "ID of the Internet Gateway"
  value       = aws_internet_gateway.igw.id
}
