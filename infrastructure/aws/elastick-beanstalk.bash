name="soft807-llanos"
version="1.0.0"
s3="soft807-llanos"
aws s3api create-bucket --bucket $s3 --region us-east-1
aws s3api put-bucket-policy --bucket $s3 --policy '{
    "Version":"2012-10-17",
    "Statement":[
        {
            "Sid":"PublicReadGetObject",
            "Effect":"Allow",
            "Principal": "*",
            "Action":["s3:GetObject"],
            "Resource":["arn:aws:s3:::soft807-llanos/*"]
        }
    ]
}'

aws elasticbeanstalk create-application --application-name $name
aws elasticbeanstalk create-environment --application-name $name \
  --environment-name "{$name}-env"--solution-stack-name "64bit Amazon Linux 2 v5.4.5 running Python 3.10"
zip -r CloudAssignment1Diego.zip .
aws elasticbeanstalk create-application-version --application-name $name \
  --version-label $version --source-bundle S3Bucket=$s3,S3Key=CloudAssignment1Diego.zip
aws elasticbeanstalk update-environment --environment-name "{$name}-env" |
  --version-label $version
