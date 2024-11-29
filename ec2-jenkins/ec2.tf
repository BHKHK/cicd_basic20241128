# AWS 리전
provider "aws" {
    region       = "us-east-1"
}

# VPC
variable "vpc_id" {
  default        = "vpc-09ba82b24a6cd8031"
}

# 보안 그룹
resource "aws_security_group" "sg1" {
  name           = "saju-us-sg-dev"
  description    = "saju-us-sg-dev"
  vpc_id = var.vpc_id

  # 인바운드 규칙
  ingress {
    description  = "ssh"
    from_port    = "22"
    to_port      = "22"
    protocol     = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
  }
  ingress {
    description  = "APP"
    from_port    = "3000"
    to_port      = "3000"
    protocol     = "tcp"
    cidr_blocks  = ["0.0.0.0/0"]
  }

  # 아웃 바운드 규칙
  egress {
    from_port    = 0
    to_port      = 0
    protocol     = "-1"
    cidr_blocks  = ["0.0.0.0/0"]
  }

  tags = {
    Name         = "saju-api-sg-dev"
    Service      = "saju-test"
  }
}

# EC2 생성
resource "aws_instance" "ec2-1" {
  ami                    = "ami-0166fe664262f664c"       # AMI ID
  instance_type          = "t2.micro"                    # 인스턴스 유형
  key_name               = "saju-key-dev"                # 키 페어 설정
  vpc_security_group_ids = [aws_security_group.sg1.id]   # 보안그룹 설정
  availability_zone      = "us-east-1a"                  # 가용영역 설정
  user_data              = file("./userdata.sh")         # 사용자 데이터
  
  # 볼륨 설정
  root_block_device {
    volume_size  = 20
    volume_type  = "gp2"
  }

  tags = {
    Name         = "saju-api-ec2-dev"
    Service      = "saju-test"
  }

}

# 탄력적 IP 주소 할당
# 위치 : EC2 > 네트워크 및 보안 > 탄력적 IP
# 
resource "aws_eip" "eip" {
  instance = aws_instance.ec2-1.id

  tags = {
    Name         = "saju-eip-api"
    Service      = "saju-test"
  }
}

# 탄력적 IP를 ec2에 연결
output "eip_ip" {
  value = aws_eip.eip.public_ip
}
