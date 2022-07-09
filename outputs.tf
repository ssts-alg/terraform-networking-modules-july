output "subnet_ids" {
  value = aws_subnet.test_subnet.*.id
}
output "vpc_id" {
  value = aws_vpc.test_vpc.id
}
