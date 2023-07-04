#!/bin/bash

# Set variables
EB_APP_NAME="your-eb-app-name"
EB_ENV_NAME="your-eb-env-name"
RDS_INSTANCE_IDENTIFIER="your-rds-instance-identifier"
DB_NAME="your-db-name"
DB_USERNAME="your-db-username"
DB_PASSWORD="your-db-password"

# Create Elastic Beanstalk application
aws elasticbeanstalk create-application --application-name $EB_APP_NAME

# Create Elastic Beanstalk environment
aws elasticbeanstalk create-environment --application-name $EB_APP_NAME --environment-name $EB_ENV_NAME --solution-stack-name "64bit Amazon Linux 2 v3.4.6 running Python 3.8"

# Configure RDS database

# Wait for RDS database to be available
aws rds wait db-instance-available --db-instance-identifier $RDS_INSTANCE_IDENTIFIER

# Create Elastic Beanstalk environment configuration file
cat <<EOF >.ebextensions/db.config
option_settings:
  aws:rds:dbinstance:
    DBInstanceIdentifier: $RDS_INSTANCE_IDENTIFIER
    DBName: $DB_NAME
    DBUser: $DB_USERNAME
    DBPassword: $DB_PASSWORD
EOF

# Deploy the application
eb deploy --profile your-aws-profile-name --region your-aws-region --label your-deployment-label
