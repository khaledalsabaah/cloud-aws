variable "vpc_name" {
  type        = string
  description = "SimpleTerraformAWSProj VPC 1"
}

variable "vpc_cidr" {
  type        = string
  description = "Public Subnet CIDR values"
}

variable "cidr_public_subnet" {
  type        = list(string)
  description = "Public Subnet CIDR values"
}

variable "cidr_private_subnet" {
  type        = list(string)
  description = "Private Subnet CIDR values"
}

variable "us_availability_zone" {
  type        = list(string)
  description = "Availability Zones"
}

variable "public_key" {
  type        = string
  description = "Public key for EC2 instance"
}

variable "ec2_ami_id" {
  type        = string
  description = "AMI Id for EC2 Amazon Linux instance"
}

variable "ec2_user_data_install" {
  type = string
  description = "Script for installing the Python Flask API"
}

variable "domain_name" {
  type = string
  description = "Name of the domain"
}