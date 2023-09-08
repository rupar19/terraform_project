# Create Security group 
resource "aws_security_group" "alb-sg" {
  name        = "${var.project}-alb-sg"
  description = "Allow HHTP inbound traffic"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "HTTP from anywhere"
    from_port        = 80
    to_port          = 80
    protocol         = "TCP"
    cidr_blocks      = ["0.0.0.0/0"]
     }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
     }

  tags = {
    Name = "${var.project}-alb-sg"
  }
}

# Create Application Loadbalancer
resource "aws_lb" "as-alb" {
  name               = "${var.project}-alb"
  internal           = false
  load_balancer_type = "application"
  security_groups    = [aws_security_group.alb-sg.id]
  subnets            = [aws_subnet.public-subnet-1.id,aws_subnet.public-subnet-2.id,aws_subnet.public-subnet-3.id]
  
    }
# Create target group
resource "aws_lb_target_group" "as-tg" {
  name     = "${var.project}-tg"
  port     = 80
  protocol = "HTTP"
  vpc_id   = aws_vpc.main.id

  health_check {
    path = "/"
    port = 80
  }
}

# Create alb listener
resource "aws_alb_listener" "http_listener" {
  load_balancer_arn = aws_lb.as-alb.arn
  port              = "80"
  protocol          = "HTTP"
  default_action {
    type             = "forward"
    target_group_arn = aws_lb_target_group.as-tg.arn
  }
}
