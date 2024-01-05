output "vpc_id" {
  value = aws_vpc.myvpc.id
}

output "igw_id" {
  value = aws_internet_gateway.igw.id
}

output "pub_sub_id" {
  value = aws_subnet.public_subs[*].id
}

output "pvt_sub_id" {
  value = aws_subnet.private_subs[*].id
}
