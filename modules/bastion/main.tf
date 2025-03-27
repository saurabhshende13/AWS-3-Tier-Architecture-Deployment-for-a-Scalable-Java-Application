resource "aws_instance" "bastion" {
  ami                    = var.bastion_ami
  instance_type          = var.bastion_instance_type
  subnet_id              = var.subnet_id
  vpc_security_group_ids = [var.security_group_id]
  key_name               = var.key_name
  
  root_block_device {
    volume_size = 20
    encrypted   = true
  }
  
  user_data = <<-EOF
    #!/bin/bash
    hostnamectl set-hostname bastion
    apt-get update -y
    apt-get upgrade -y
    
    echo "ClientAliveInterval 60" >> /etc/ssh/sshd_config
    echo "MaxAuthTries 3" >> /etc/ssh/sshd_config
    
    systemctl restart ssh
  EOF
  
  tags = {
    Name = "${var.environment}-bastion"
  }
}

resource "aws_eip" "bastion" {
  instance = aws_instance.bastion.id
  vpc      = true
  
  tags = {
    Name = "${var.environment}-bastion-eip"
  }
}