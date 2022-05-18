echo "Version #1" > test2.txt

aws --profile svc-PRIVATE_USER s3api create-bucket --bucket 5bucket --acl private --region us-east-1
aws --profile svc-PRIVATE_USER s3api put-bucket-versioning --bucket 5bucket --versioning-configuration Status=Enabled
aws --profile svc-PRIVATE_USER s3 cp test.txt s3://5bucket/test2.txt
