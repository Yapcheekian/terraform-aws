variable "vpc_cidr" {
    type = string
}

variable "public_cidrs" {
    type = list
}

variable "private_cidrs" {
    type = list
}

variable "public_subnet_count" {
    type = string
}

variable "private_subnet_count" {
    type = string
}