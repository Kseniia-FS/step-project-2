provider "aws" {
  region = "eu-north-1"
}

resource "aws_instance" "jenkins_master" {
  ami           = "ami-075449515af5df0d1"
  instance_type = "t3.medium"
  key_name      = var.key_name
  tags = {
    Name = "Jenkins_Master"
  }

  user_data = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y openjdk-11-jdk wget curl gnupg
    curl -fsSL https://pkg.jenkins.io/debian-stable/jenkins.io.key | tee \
    /usr/share/keyrings/jenkins-keyring.asc > /dev/null
    echo deb [signed-by=/usr/share/keyrings/jenkins-keyring.asc] \
    https://pkg.jenkins.io/debian-stable binary/ | tee \
    /etc/apt/sources.list.d/jenkins.list > /dev/null
    apt-get update
    apt-get install -y jenkins
    systemctl enable jenkins
    systemctl start jenkins
  EOT
}

output "jenkins_master_public_ip" {
  value = aws_instance.jenkins_master.public_ip
}

resource "aws_instance" "jenkins_worker" {
  ami           = "ami-075449515af5df0d1"
  instance_type = "t3.medium"
  key_name      = var.key_name
  tags = {
    Name = "Jenkins_Worker"
  }

  user_data = <<-EOT
    #!/bin/bash
    apt-get update
    apt-get install -y openjdk-11-jdk docker.io
    usermod -aG docker ubuntu
  EOT
}

output "jenkins_worker_public_ip" {
  value = aws_instance.jenkins_worker.public_ip
}

