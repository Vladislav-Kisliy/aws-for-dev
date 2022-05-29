echo "Version #1" > test2.txt 

aws --profile svc-PRIVATE_USER s3api create-bucket --bucket 4mybucket --acl private --region us-east-1
aws --profile svc-PRIVATE_USER s3api put-bucket-versioning --bucket 4mybucket --versioning-configuration Status=Enabled
aws --profile svc-PRIVATE_USER s3 cp test.txt s3://4mybucket/test2.txt
