variable "lb_target_group_name" {}
variable "lb_target_group_port" {}
variable "lb_target_group_protocol" {}
variable "vpc_id" {}
variable "ec2_instance_id" {}

output "lb_target_group_arn" {
  value = aws_lb_target_group.lb_target_group_1.arn
}

resource "aws_lb_target_group" "lb_target_group_1" {
  name     = var.lb_target_group_name
  port     = var.lb_target_group_port
  protocol = var.lb_target_group_protocol
  vpc_id   = var.vpc_id
  health_check {
    path = "/health"
    port = 5000
    healthy_threshold = 6
    unhealthy_threshold = 2
    timeout = 2
    interval = 5
    matcher = "200"  # has to be HTTP 200 or fails
  }
}

resource "aws_lb_target_group_attachment" "lb_target_group_attachment_1" {
  target_group_arn = aws_lb_target_group.lb_target_group_1.arn
  target_id        = var.ec2_instance_id
  port             = 5000
}