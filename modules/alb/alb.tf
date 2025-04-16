
resource "aws_lb" "alb" {
  name               = var.alb_name 
  internal           = var.internal 
  load_balancer_type = var.load_balancer_type
  security_groups    = [var.security_groups.id]   #[aws_security_group.alb_sg.id]
  subnets            = var.public_subnets_ids  # Must be in *public* subnets

  tags = var.tags
}


resource "aws_lb_listener" "alb_listener" {
  load_balancer_arn = aws_lb.alb.arn
  port              = 80
  protocol          = "HTTP"

  default_action {
    type             = "forward"
    target_group_arn = var.target_group_arn    #aws_lb_target_group.ecs_tg.arn
  }
}
