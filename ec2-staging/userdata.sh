#!/bin/bash

# Amazon Linux 시간 설정
sudo timedatectl set-timezone 'Asia/Seoul'

# Docker 설치
yum install -y docker
systemctl enable docker
systemctl start docker
systemctl status docker
usermod -aG docker ec2-user
