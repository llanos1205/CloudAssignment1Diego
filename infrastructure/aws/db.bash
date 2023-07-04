
# Set variables

RDS_INSTANCE_IDENTIFIER="soft807"
DB_NAME="catalog"
DB_USERNAME="awsuser"
DB_PASSWORD="LL@ltair1205"
# Set variables
VPC_ID="soft807"
SUBNET_CIDR="10.0.0.0/24"
AVAILABILITY_ZONE="us-east-1a"

aws rds create-db-instance --db-instance-identifier $RDS_INSTANCE_IDENTIFIER --db-instance-class db.t2.micro --engine mysql --allocated-storage 20 --db-name $DB_NAME --master-username $DB_USERNAME --master-user-password $DB_PASSWORD
