
output "vpc_id" {
  value       = aws_vpc.vpc.id
  description = "VPC ID"
}

output "wavelength_subnet" {
  value       = aws_subnet.wavelength_subnets.id
  description = "Wavelength Subnet created."
}
output "route_table_id" {
  value       = aws_route_table.vpc_routetable_wavelength.id
  description = "Route table ID for the Wavelength subnet."
}
