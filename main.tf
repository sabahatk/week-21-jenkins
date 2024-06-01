#Set providers to AWS
terraform {
  required_providers {
    aws = {
      source = "hashicorp/aws"
    }
  }
}

provider "aws" {
  region = "us-east-1"
}

#Add security group to allow port 22 and 8080 traffic
resource "aws_security_group" "TF_SG" {
  name        = "security group using Terraform"
  description = "security group using Terraform"
  vpc_id      = "vpc-00bdbfa80f37bd0fe"

  ingress {
    description = "SSH"
    from_port   = 22
    to_port     = 22
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  ingress {
    description = "Jenkins"
    from_port   = 8080
    to_port     = 8080
    protocol    = "tcp"
    cidr_blocks = ["0.0.0.0/0"]
  }

  egress {
    from_port   = 0
    to_port     = 0
    protocol    = "-1"
    cidr_blocks = ["0.0.0.0/0"]
  }

  tags = {
    Name = "TF_SG"
  }
}

#create s3 bucket
resource "aws_s3_bucket" "TF_Bucket" {
  bucket = "my-tf-jenkins-bucket-may-2024-i382k4m2l"
  
  tags = {
    Name = "Jenkins Bucket"
  }
}

#Create instance
resource "aws_instance" "jenkins" {
  ami             = "ami-00beae93a2d981137"
  instance_type   = "t2.micro"
  vpc_security_group_ids = [aws_security_group.TF_SG.id]

  tags = {
    Name = "JenkinsInstance"
  }
  user_data = file("~/environment/terraform-project-week21/user-data.sh")
}