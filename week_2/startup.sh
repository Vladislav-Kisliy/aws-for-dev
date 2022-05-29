#!/bin/bash

aws s3 ls s3://4mybucket > /tmp/access_check.log
aws s3 cp s3://4mybucket/test2.txt ./
