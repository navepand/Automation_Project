#!/bin/bash

myname="Naveen"
s3_bucket="upgrad-naveen"


sudo apt update -y
sudo apt install apache2
ps -eo comm,etime,user | grep root | grep apache2
sudo systemctl enable apache2
sudo tar -cvf Naveen-httpd-logs-$(date '+%d%m%Y-%H%M%S').tar /var/log/apache2/*.log
sudo mv Naveen-httpd-logs-$(date '+%d%m%Y-%H%M%S').tar /tmp


aws s3 cp /tmp/$myname-httpd-logs-$(date '+%d%m%Y-%H%M%S').tar s3://$s3_bucket/$myname-httpd-logs-$(date '+%d%m%Y-%H%M%S').tar
