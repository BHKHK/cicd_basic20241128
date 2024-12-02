#!/bin/bash

# Amazon Linux 시간 설정
sudo timedatectl set-timezone 'Asia/Seoul'

# X-Window 시스템 및 GUI 유틸 설치
yum install -y xorg-x11-xauth
yum install -y dbus-x11
yum install -y nautilus
yum install -y gnome-system-monitor
yum install -y gedit
yum install -y git

# 한글 폰트 설치
yum install -y fonts-korean
fc-cache -r
cd /usr/share/fonts/
wget http://cdn.naver.com/naver/NanumFont/fontfiles/NanumFont_TTF_ALL.zip
unzip NanumFont_TTF_ALL.zip -d NanumFont
rm -f NanumFont_TTF_ALL.zip
fc-cache -r

# JAVA 11 설치
yum install -y java-11-amazon-corretto.x86_64

# Chrome 브라우저 설치
wget https://dl.google.com/linux/direct/google-chrome-stable_current_x86_64.rpm
yum install -y ./google-chrome-stable_current_x86_64.rpm

# Docker 설치
yum install -y docker
systemctl enable docker
systemctl start docker
systemctl status docker
usermod -aG docker ec2-user
curl https://raw.githubusercontent.com/docker/docker-ce/master/components/cli/contrib/completion/bash/docker -o /etc/bash_completion.d/docker.sh

# SonarQube 도커 실행
docker run -d --name=sonarqube -p 9000:9000 --restart=always sonarqube:8.6-community
docker container ls -a
chrome

