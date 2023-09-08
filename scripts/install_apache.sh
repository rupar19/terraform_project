#!/bin/bash

yum update -y
yum install httpd -y
echo "this instance is : $(hostname)" >> /var/www/html/index.html
systemctl start httpd
