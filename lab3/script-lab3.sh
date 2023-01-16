#!/bin/bash

aws ec2 create-key-pair --key-name lab3-key --query 'KeyMaterial' --output text > lab3-key.pem 
chmod 400 lab3-key.pem 
vpc_id=$(aws ec2 describe-vpcs --query 'Vpcs[0].VpcId' --output text) 
aws ec2 create-security-group --group-name lab3-secutity --description "creating security group for lab 3" 
security_group=$(aws ec2 describe-security-groups --query 'SecurityGroups[0].GroupId' --output text)
aws ec2 authorize-security-group-ingress --group-id $security_group --protocol tcp --port 22 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $security_group  --protocol tcp --port 80 --cidr 0.0.0.0/0
aws ec2 authorize-security-group-ingress --group-id $security_group  --protocol tcp --port 443 --cidr 0.0.0.0/0
network_id=$(aws ec2 describe-subnets --query 'Subnets[0].SubnetId' --output text) 
instance_id=$(aws ec2 run-instances --image-id ami-0a261c0e5f51090b1 --count 1 --instance-type t2.micro \
--key-name lab3-key --security-group-ids $SG --user-data file://user_data.sh --query 'Instances[*].[InstanceId]' --output text)
aws ec2 create-tags --resources $instance_id --tags Key=Role,Value=WebServer 
echo $instance_id 