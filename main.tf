#Add security group to allow port 22 and 8080 traffic
resource "aws_security_group" "TF_SG" {
  name        = var.sg_name
  description = var.sg_name
  vpc_id      = var.vpc_id

  ingress {
    description = var.ssh_desc
    from_port   = var.ssh_port
    to_port     = var.ssh_port
    protocol    = var.protocol_tcp
    cidr_blocks = var.cidr_block
  }

  ingress {
    description = var.jenkins_desc
    from_port   = var.jenkins_port
    to_port     = var.jenkins_port
    protocol    = var.protocol_tcp
    cidr_blocks = var.cidr_block
  }

  egress {
    from_port   = var.outbound_port
    to_port     = var.outbound_port
    protocol    = var.protocol_outbound
    cidr_blocks = var.cidr_block
  }

  tags = {
    Name = var.sg_tag
  }
}

#create s3 bucket
resource "aws_s3_bucket" "TF_Bucket" {
  bucket = var.bucket_name

  tags = {
    Name = var.bucket_tag
  }
}

#Create instance
resource "aws_instance" "jenkins" {
  ami                    = var.ami_id
  instance_type          = var.instance_type_name
  vpc_security_group_ids = [aws_security_group.TF_SG.id]

  tags = {
    Name = var.instance_name
  }
  user_data = file(var.ud_filepath)
}
