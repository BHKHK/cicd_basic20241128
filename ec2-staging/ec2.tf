# AWS 리전
provider "aws" {
    region         = "us-east-1"
}

# VPC
variable "vpc_id" {
  default          = "vpc-09ba82b24a6cd8031"
}

# ENI
resource "aws_network_interface" "eni" {
  subnet_id        = "subnet-0199fa58772912cfe"
  private_ips      = ["172.31.90.100"]
  security_groups  = ["sg-08b376602ead799b0"]
  tags = {
    Name           = "stage-eni-cicd"
  }
}


# EC2 생성
resource "aws_instance" "ec2" {
  ami                    = "ami-0453ec754f44f9a4a"       # AMI ID
  instance_type          = "t2.micro"                    # 인스턴스 유형
  key_name               = "saju-key-test"               # 키 페어 설정
  # vpc_security_group_ids = ["sg-08b376602ead799b0"]    # 보안그룹 설정
  availability_zone      = "us-east-1a"                  # 가용영역 설정
  user_data              = file("./userdata.sh")         # 사용자 데이터
  
  network_interface {
    network_interface_id = aws_network_interface.eni.id
    device_index         = 0
  }
  # 볼륨 설정
  root_block_device {
    volume_size  = 30
    volume_type  = "gp3"
  }

  tags = {
    Name         = "stage-ec2-cicd"
    Service      = "cicd-test"
  }

}

# 탄력적 IP 주소 할당
# 위치 : EC2 > 네트워크 및 보안 > 탄력적 IP
# 
resource "aws_eip" "eip" {
  instance = aws_instance.ec2.id

  tags = {
    Name         = "stage-eip-cicd"
    Service      = "cicd-test"
  }
}

# 탄력적 IP를 ec2에 연결
output "eip_ip" {
  value = aws_eip.eip.public_ip
}
