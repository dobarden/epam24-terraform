terraform {
  required_providers {
    aws = {
      source  = "hashicorp/aws"
      version = "~> 4.0"
    }
  }
  required_version = "~> 1.0"
}

provider "aws" {
  access_key = var.aws_access_key
  secret_key = var.aws_secret_key
  region     = var.aws_region
}

#-----------------EC2---------------------

resource "aws_instance" "ec2-task02" {
  ami                    = "ami-064ff912f78e3e561"
  instance_type          = "t2.micro"
  vpc_security_group_ids = [aws_security_group.nginx-sg.id]
  user_data              = <<EOF
#!/bin/bash
sudo amazon-linux-extras install -y nginx1
sudo systemctl start nginx
EOF

  tags = {
    Name = "Nginx Server Build by Terraform"
  }
}

#------------------RDS----------------

resource "aws_db_instance" "my-db" {
  identifier             = "terraform-rds-aws"
  allocated_storage      = 10
  engine                 = "mysql"
  engine_version         = "5.7"
  instance_class         = "db.t2.micro"
  db_name                = var.rds_database
  username               = var.rds_username
  password               = data.aws_ssm_parameter.my_rds_password.value
  skip_final_snapshot    = true
  vpc_security_group_ids = [aws_security_group.rds.id]
  publicly_accessible = true

  tags = {
     Name = "AWS RDS Build by Terraform"
   }

}

#-------------RDS password--------------

resource "random_string" "rds_password" {
  length = 8
  special = false
}

resource "aws_ssm_parameter" "rds_password" {
  name        = "rds-mysql"
  type        = "SecureString"
  value       = random_string.rds_password.result
  description = "Master pass for RDS MySQL"
}

data "aws_ssm_parameter" "my_rds_password" {
  name = "rds-mysql"

  depends_on = [aws_ssm_parameter.rds_password]
}


#------------------SG-----------------

resource "aws_security_group" "nginx-sg" {
  name   = "terraform-nginx-sg"

  ingress {
    from_port   = 80
    protocol    = "tcp"
    to_port     = 80
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-nginx-sg"
  }
}

resource "aws_security_group" "rds" {
  name   = "terraform-rds-sg"

  ingress {
    from_port       = 3306
    protocol        = "tcp"
    to_port         = 3306
    cidr_blocks = ["0.0.0.0/0"]

  }

  egress {
    from_port   = 0
    protocol    = "-1"
    to_port     = 0
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "terraform-rds-sg"
  }
}