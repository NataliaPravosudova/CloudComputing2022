#!/bin/bash

yum update -y
yum install httpd -y
systemctl start httpd
systemctl enable httpd
touch /var/www/html/index.html
echo "<h1>Hi user! Server is running. Hostname: $(hostname -f) </h1>" > /var/www/html/index.html