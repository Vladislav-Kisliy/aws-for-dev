#!/bin/bash

aws --profile svc-PRIVATE_USER s3api create-bucket --bucket 4mybucket --acl private --region us-east-1
aws --profile svc-PRIVATE_USER s3api put-bucket-versioning --bucket 4mybucket --versioning-configuration Status=Enabled
aws --profile svc-PRIVATE_USER s3 cp rds-script.sql s3://4mybucket/rds-script.sql
aws --profile svc-PRIVATE_USER s3 cp dynamodb-script.sh s3://4mybucket/dynamodb-script.sh
