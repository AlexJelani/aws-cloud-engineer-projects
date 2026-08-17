data "aws_availability_zones" "available" {
  state = "available"
}

data "aws_caller_identity" "current" {}

data "aws_region" "current" {}

locals {
  azs = slice(data.aws_availability_zones.available.names, 0, 2)

  public_subnet_cidrs = [
    "10.40.1.0/24",
    "10.40.2.0/24",
  ]

  private_subnet_cidrs = [
    "10.40.10.0/24",
    "10.40.11.0/24",
  ]

  isolated_subnet_cidrs = [
    "10.40.20.0/24",
    "10.40.21.0/24",
  ]
}
