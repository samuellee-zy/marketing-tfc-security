module "vpc" {
  source = "terraform-aws-modules/vpc/aws"

  name = "my-vpc"
  cidr = "10.0.0.0/16"

  azs             = ["ap-southeast-2a", "ap-southeast-2b", "ap-southeast-2c"]
  private_subnets = ["10.0.1.0/24", "10.0.2.0/24", "10.0.3.0/24"]
  public_subnets  = ["10.0.101.0/24", "10.0.102.0/24", "10.0.103.0/24"]

  enable_nat_gateway = true
  enable_vpn_gateway = true

  tags = {
    Terraform = "true"
    Environment = "dev"
  }
}

module "web_server_sg" {
  depends_on = [
    module.vpc
  ]
  source = "terraform-aws-modules/security-group/aws//modules/http-80"

  name        = "web-server"
  description = "Security group for web-server with HTTP ports open within VPC"
  vpc_id      = "vpc-018d5fc932f81e495"

  ingress_cidr_blocks = ["10.10.0.0/16"]
}

module "ec2_instance" {
  source  = "terraform-aws-modules/ec2-instance/aws"
  version = "~> 3.0"

  for_each = toset(["uno", "dos", "tres"])

  name = "instance-${each.key}"

  ami                    = "ami-023dd49682f8a7c2b"
  instance_type          = "t2.micro"
  monitoring             = true
  vpc_security_group_ids = ["sg-03248ac9f9ec3c0f7"]
  subnet_id              = "subnet-0eb16890f41554b49"

  tags = {
    Terraform   = "true"
    Environment = "dev"
  }
}

