variable "lb_name" {}
variable "lb_type" {}
variable "is_external" { default = false }
variable "sg_enable_ssh_https" {}
variable "sg_enable_http" {}
variable "subnet_ids" {}
variable "lb_target_group_arn" {}
variable "ec2_instance_id" {}
variable "lb_listner_port" {}
variable "lb_listner_protocol" {}
variable "lb_listner_default_action" {}
variable "lb_https_listner_port" {}
variable "lb_https_listner_protocol" {}
variable "dev_proj_1_acm_arn" {}
variable "lb_target_group_attachment_port" {}

output "aws_lb_dns_name" {
  value = aws_lb.lb_1.dns_name
}

output "aws_lb_zone_id" {
  value = aws_lb.lb_1.zone_id
}


resource "aws_lb" "lb_1" {
  name               = var.lb_name
  internal           = var.is_external
  load_balancer_type = var.lb_type
  security_groups    = [var.sg_enable_ssh_https, var.sg_enable_http]
  subnets            = var.subnet_ids # Replace with your subnet IDs

  enable_deletion_protection = false

  tags = {
    Name = "lb-1"
  }
}

resource "aws_lb_target_group_attachment" "lb_target_group_attachment" {
  target_group_arn = var.lb_target_group_arn
  target_id        = var.ec2_instance_id # Replace with your EC2 instance reference
  port             = var.lb_target_group_attachment_port
}

resource "aws_lb_listener" "lb_listener" {
  load_balancer_arn = aws_lb.lb_1.arn
  port              = var.lb_listner_port
  protocol          = var.lb_listner_protocol

  default_action {
    type             = var.lb_listner_default_action
    target_group_arn = var.lb_target_group_arn
  }
}

# https listner on port 443
resource "aws_lb_listener" "lb_https_listener" {
  load_balancer_arn = aws_lb.lb_1.arn
  port              = var.lb_https_listner_port
  protocol          = var.lb_https_listner_protocol
  ssl_policy        = "ELBSecurityPolicy-FS-1-2-Res-2019-08"
  certificate_arn   = var.dev_proj_1_acm_arn

  default_action {
    type             = var.lb_listner_default_action
    target_group_arn = var.lb_target_group_arn
  }
}