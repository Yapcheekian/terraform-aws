resource "random_integer" "random" {
    min = 1
    max = 5
}

resource "aws_vpc" "yap_vpc" {
    cidr_block = var.vpc_cidr
    enable_dns_hostnames = true
    enable_dns_support = true

    tags = {
      "Name" = "yap_vpc_${random_integer.random.id}"
    }
}