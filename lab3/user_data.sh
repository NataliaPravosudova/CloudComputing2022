#!/bin/bash
yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd
touch /index.html
echo "<h1> Server is running - $(hostname -f) </h1>" > /index.html