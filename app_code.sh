#!/bin/bash
# Update the system
yum update -y

sudo su
yum install docker -y


systemctl start docker
# Enable Docker on boot
systemctl enable docker
docker pull manodayahire/grapevault
docker run -d --name GrapeVault -p 8080:80 manodayahire/grapevault:latest

echo "Docker setup complete" >> /home/ec2-user/docker-setup.log