# Create lt sg
resource "aws_security_group" "ec2-sg" {
  name        = "${var.project}-ec2-sg"
  description = "Security group for lunch template"
  vpc_id      = aws_vpc.main.id

  ingress {
    description      = "HTTP from alb sg"
    from_port        = 80
    to_port          = 80
    protocol         = "TCP"
    security_groups = [aws_security_group.alb-sg.id]
     }

  egress {
    from_port        = 0
    to_port          = 0
    protocol         = "-1"
    cidr_blocks      = ["0.0.0.0/0"]
     }

  tags = {
    Name = "${var.project}-ec2-sg"
  }
}


resource "aws_launch_template" "asg-lt" {
    name = "asg-lt"
    image_id = "${var.ami}" 
    instance_type = "t2.micro"
    vpc_security_group_ids = [aws_security_group.ec2-sg.id]
    user_data = filebase64("scripts/install_apache.sh")

    tag_specifications {
    resource_type = "instance"

    tags = {
      Name = "ec2-asg"
    }
  }
 
}


  
