locals {
  vpc_cidr = "10.0.0.0/16"
}
module "networking" {
  source               = "./networking"
  vpc_cidr             = local.vpc_cidr
  access_ip            = var.access_ip
  public_subnet_count  = 2
  private_subnet_count = 3
  max_subnets          = 20
  public_cidrs         = [for i in range(2, 8, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
  private_cidrs        = [for i in range(1, 8, 2) : cidrsubnet(local.vpc_cidr, 8, i)]
}