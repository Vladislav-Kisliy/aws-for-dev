#!/bin/bash

yum install postgresql -y
curl https://truststore.pki.rds.amazonaws.com/us-east-1/us-east-1-bundle.pem > /etc/ssl/certs/us-east-1-bundle.pem
mkdir /init_scripts
chmod 777 /init_scripts
aws s3 ls s3://4mybucket > /init_scripts/access_check.log
aws s3 cp s3://4mybucket/rds-script.sql /init_scripts
aws s3 cp s3://4mybucket/dynamodb-script.sh /init_scripts