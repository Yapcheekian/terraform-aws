module "networking" {
    source = "./networking"
    vpc_cidr = "10.0.0.0/16"
    public_cidrs = ["10.0.1.0/24", "10.0.2.0/24"]
    private_cidrs = ["10.0.15.0/24", "10.0.16.0/24"]
}
