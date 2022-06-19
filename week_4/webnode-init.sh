#!/bin/bash -xe

yum update -y
yum install -y httpd
cd /var/www/html
echo "<html><h1>This is WebServer from private subnet</h1></html>" > index.html
systemctl start httpd
service httpd start
