variable "ami_id" {}
variable "instance_type" {}
variable "tag_name" {}
variable "public_key" {}
variable "subnet_id" {}
variable "sg_enable_ssh_https" {}
variable "enable_public_ip_address" {}
variable "user_data_install_apache" {}
variable "ec2_sg_name_for_python_api" {}

output "ssh_connection_string_for_ec2" {
  value = format("%s%s", "ssh -i /Users/janvandenhouten/.ssh/simpleTerraformAWSProjKey ec2-user@", aws_instance.ec2_1.public_ip)
}

output "ec2_instance_id" {
  value = aws_instance.ec2_1.id
}

resource "aws_instance" "ec2_1" {
  ami           = var.ami_id
  instance_type = var.instance_type
  tags = {
    Name = var.tag_name
  }
  key_name                    = "simpleTerraformAWSProjKey"
  subnet_id                   = var.subnet_id
  vpc_security_group_ids      = [var.sg_enable_ssh_https, var.ec2_sg_name_for_python_api]
  associate_public_ip_address = var.enable_public_ip_address

  user_data = var.user_data_install_apache

  metadata_options {
    http_endpoint = "enabled"  # Enable the IMDSv2 endpoint
    http_tokens   = "required" # Require the use of IMDSv2 tokens
  }
}

resource "aws_key_pair" "public_key_1" {
  key_name   = "simpleTerraformAWSProjKey"
  public_key = var.public_key
}