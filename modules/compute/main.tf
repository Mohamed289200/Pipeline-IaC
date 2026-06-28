##############################################################
# Compute Module
# Resources: AMI Data Source, Key Pair, EC2 Instance,
#            Launch Template, Auto Scaling Group, ASG Policy
##############################################################

# ── Latest Amazon Linux 2023 AMI ─────────────────────────────
data "aws_ami" "amazon_linux" {
  most_recent = true
  owners      = ["amazon"]

  filter {
    name   = "name"
    values = ["al2023-ami-*"]
  }

  filter {
    name   = "architecture"
    values = ["x86_64"]
  }
}

# ── Key Pair ─────────────────────────────────────────────────
resource "aws_key_pair" "deployer" {
  key_name   = "${var.env}-deployer-key"
  public_key = var.public_key

  tags = {
    Name = "${var.env}-deployer-key"
    Env  = var.env
  }
}

# ── EC2 Bastion / Web Server Instance ────────────────────────
resource "aws_instance" "web_server" {
  ami                    = data.aws_ami.amazon_linux.id
  instance_type          = var.instance_type
  subnet_id              = var.public_subnet_1
  vpc_security_group_ids = [var.ec2_sg_id]
  key_name               = aws_key_pair.deployer.key_name

  tags = {
    Name = "${var.env}-Web-Server"
    Env  = var.env
  }

  provisioner "remote-exec" {
    inline = [
      "echo 'Provisioning ${var.env} Web Server'",
      "sudo yum update -y",
      "sudo yum install -y httpd",
      "sudo systemctl start httpd",
      "sudo systemctl enable httpd",
      "echo '<h1>${var.env} — Web Server</h1>' | sudo tee /var/www/html/index.html",
    ]

    connection {
      type        = "ssh"
      user        = "ec2-user"
      private_key = file(var.private_key_path)
      host        = self.public_ip
      timeout     = "3m"
    }
  }
}

# ── Launch Template ──────────────────────────────────────────
resource "aws_launch_template" "web_lt" {
  name_prefix   = "${var.env}-web-template-"
  image_id      = data.aws_ami.amazon_linux.id
  instance_type = var.instance_type

  vpc_security_group_ids = [var.ec2_sg_id]

  user_data = base64encode(<<-EOF
    #!/bin/bash
    yum update -y
    yum install -y httpd
    systemctl start httpd
    systemctl enable httpd
    echo "<h1>${var.env} — Terraform Auto Scaling Server</h1>" > /var/www/html/index.html
  EOF
  )

  tag_specifications {
    resource_type = "instance"
    tags = {
      Name = "${var.env}-ASG-WebServer"
      Env  = var.env
    }
  }

  lifecycle {
    create_before_destroy = true
  }
}

# ── Auto Scaling Group ───────────────────────────────────────
resource "aws_autoscaling_group" "web_asg" {
  name = "${var.env}-web-asg"

  desired_capacity = var.asg_desired
  min_size         = var.asg_min
  max_size         = var.asg_max

  vpc_zone_identifier = [
    var.public_subnet_1,
    var.public_subnet_2,
  ]

  target_group_arns = [var.target_group_arn]

  launch_template {
    id      = aws_launch_template.web_lt.id
    version = "$Latest"
  }

  health_check_type         = "ELB"
  health_check_grace_period = 120

  tag {
    key                 = "Name"
    value               = "${var.env}-ASG-Web"
    propagate_at_launch = true
  }

  tag {
    key                 = "Env"
    value               = var.env
    propagate_at_launch = true
  }
}

# ── Auto Scaling Policy (CPU Target Tracking) ────────────────
resource "aws_autoscaling_policy" "cpu_policy" {
  name                   = "${var.env}-cpu-policy"
  autoscaling_group_name = aws_autoscaling_group.web_asg.name
  policy_type            = "TargetTrackingScaling"

  target_tracking_configuration {
    predefined_metric_specification {
      predefined_metric_type = "ASGAverageCPUUtilization"
    }
    target_value = var.cpu_target_value
  }
}
