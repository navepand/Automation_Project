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

tarfiles=$(find /var -type f -iname "*.tar")
for tarfile in $tarfiles 
do 
    files=$(basename -- "$tarfiles")
    file_name="${files%.*}"
    file_type="${files##*.}"
    log_type=$(echo $file_name | awk -F'-' 'BEGIN{OFS="-"} {print $2, $3}')
    date_created=$(echo $file_name | awk -F'-' 'BEGIN{OFS="-"} {print $4, $5}')
    file_size=$(du -h "$tarfiles")
    size=$(echo $file_size | awk '{print $1}') 
    echo -e $log_type ' \t ' $date_created ' \t ' $file_type ' \t ' $size >> /var/www/html/inventory.html
done

{ crontab -l; echo "0 0 * * * /root/Automation_Project/automation.sh/"; } | crontab -
