#!/bin/bash

# Create VPC
vpcId=$(aws ec2 create-vpc --cidr-block 10.0.0.0/16 --output text --query 'Vpc.VpcId')
aws ec2 modify-vpc-attribute --vpc-id $vpcId --enable-dns-support '{"Value": true}'
aws ec2 modify-vpc-attribute --vpc-id $vpcId --enable-dns-hostnames '{"Value": true}'
echo "Created VPC with ID: $vpcId"

# Create Subnets
subnetId1=$(aws ec2 create-subnet --vpc-id $vpcId --cidr-block 10.0.1.0/24 --availability-zone us-east-1a --output text --query 'Subnet.SubnetId')
subnetId2=$(aws ec2 create-subnet --vpc-id $vpcId --cidr-block 10.0.2.0/24 --availability-zone us-east-1b --output text --query 'Subnet.SubnetId')
echo "Created subnets:"
echo "Subnet 1: $subnetId1"
echo "Subnet 2: $subnetId2"

# Create Internet Gateway
gatewayId=$(aws ec2 create-internet-gateway --output text --query 'InternetGateway.InternetGatewayId')
echo "Created Internet Gateway with ID: $gatewayId"

# Attach Internet Gateway to VPC
aws ec2 attach-internet-gateway --vpc-id $vpcId --internet-gateway-id $gatewayId
echo "Attached Internet Gateway to VPC"

# Create Route Table
routeTableId=$(aws ec2 create-route-table --vpc-id $vpcId --output text --query 'RouteTable.RouteTableId')
echo "Created Route Table with ID: $routeTableId"

# Create Route in Route Table
aws ec2 create-route --route-table-id $routeTableId --destination-cidr-block 0.0.0.0/0 --gateway-id $gatewayId
echo "Created route in Route Table"

# Associate Subnets with Route Table
aws ec2 associate-route-table --subnet-id $subnetId1 --route-table-id $routeTableId
aws ec2 associate-route-table --subnet-id $subnetId2 --route-table-id $routeTableId
echo "Associated subnets with Route Table"

# Create Security Group
securityGroupId=$(aws ec2 create-security-group --group-name my-security-group --description "My Security Group" --vpc-id $vpcId --output text --query 'GroupId')
echo "Created Security Group with ID: $securityGroupId"

# Configure Security Group Inbound Rules
aws ec2 authorize-security-group-ingress --group-id $securityGroupId --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $securityGroupId --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $securityGroupId --protocol tcp --port 1433 --cidr 0.0.0.0/0
echo "Configured Security Group inbound rules"

# Create Subnet Group
subnetGroupName="my-subnet-group"
subnetGroupDescription="My subnet group description"
subnetGroupArn=$(aws rds create-db-subnet-group --db-subnet-group-name $subnetGroupName --db-subnet-group-description "$subnetGroupDescription" --subnet-ids $subnetId1 $subnetId2 --output text --query 'DBSubnetGroup.DBSubnetGroupArn')
echo "Created Subnet Group with ARN: $subnetGroupArn"

# Create Internet Gateway, Route Table, Security Group, and other resources (same as before)

# Create RDS Instance
rdsInstanceId=$(aws rds create-db-instance --engine sqlserver-ex --engine-version 14.00.3281.6.v1 --db-instance-identifier my-db-instance --allocated-storage 20 --db-instance-class db.t3.small --master-username admin --master-user-password admin123 --backup-retention-period 0 --storage-type standard --port 1433 --publicly-accessible --db-subnet-group-name $subnetGroupName --output text --query 'DBInstance.DBInstanceIdentifier')


echo "Created RDS Instance with ID: $rdsInstanceId"

# Print Outputs
echo "VPC ID: $vpcId"
echo "Subnet 1 ID: $subnetId1"
echo "Subnet 2 ID: $subnetId2"
echo "Internet Gateway ID: $gatewayId"
echo "Route Table ID: $routeTableId"
echo "Security Group ID: $securityGroupId"
echo "RDS Instance ID: $rdsInstanceId"
