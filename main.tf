#Creating VPC using local module
module "vpc" {
  source                           = "./modules/vpc"
  vpc_cidr                         = var.vpc_cidr
  identifier                       = var.project_identifier
  wavelength_subnet_identifier = var.wavelength_subnet_identifier
  wavelength_subnet_cidrs      = var.wavelength_subnet_cidr
  availabilityzone_wavelength  = var.availabilityzone_wavelength
}

#Creating EC2 instances using local module
module "compute" {
  source                             = "./modules/compute"
  ec2_count                          = var.ec2_count
  instance_type_wavelength       = var.instance_type_wavelength
  instance_identifier_wavelength = var.instance_identifier_wavelength
  availabilityzone_wavelength    = var.availabilityzone_wavelength
  instance_subnet_wavelength     = module.vpc.wavelength_subnet
  ami_id                             = var.ami_id
}

terraform {
  backend "s3" {
    bucket         = "terraform-state-sonatel"
    key            = "env/dev/terraform.tfstate"
    region         = "eu-west-3"
    encrypt        = true
    use_lockfile   = true 
     profile       = "terraform"
  }
}

resource "aws_vpc_endpoint" "s3_endpoint" {
  vpc_id            = module.vpc.vpc_id  # or aws_vpc.vpc.id if local
  service_name      = "com.amazonaws.${var.region}.s3"
  vpc_endpoint_type = "Gateway"

  route_table_ids = [
    module.vpc.route_table_id  # adjust if needed
  ]

  tags = {
    Name = "VPC Endpoint for S3"
  }
}

