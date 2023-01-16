#!/bin/bash

aws ec2 create-vpc --cidr-block 10.0.0.0/16 
 vpc_id=$(aws ec2 describe-vpcs --query 'Vpcs[0].VpcId' --output text) 
 aws ec2 create-subnet --vpc-id $vpc_id --cidr-block 10.0.1.0/24 
 network1_id=$(aws ec2 describe-subnets --query 'Subnets[0].SubnetId' --output text) 
 aws ec2 create-subnet --vpc-id $vpc_id --cidr-block 10.0.2.0/24 
 aws ec2 create-internet-gateway 
 internet_gateways=$(aws ec2 describe-internet-gateways --query 'InternetGateways[0].InternetGatewayId' --output text) 
 aws ec2 attach-internet-gateway --internet-gateway-id $internet_gateways --vpc-id $vpc_id 
 allocation_id=$(aws ec2 describe-addresses --query 'Addresses[0].AllocationId' --output text) 
 aws ec2 create-nat-gateway --subnet-id $network1_id --allocation-id $allocation_id 
 nat=$(aws ec2 describe-nat-gateways --query 'NatGateways[-1].NatGatewayId' --output text) 
 aws ec2 create-route-table --vpc-id $vpc_id 
 route_tables_id=$(aws ec2 describe-route-tables --query 'RouteTables[0].RouteTableId' --output text) 
 aws ec2 create-route --route-table-id $route_tables_id --destination-cidr-block 0.0.0.0/0 --gateway-id $internet_gateways 
 aws ec2 associate-route-table --route-table-id $route_tables_id --subnet-id $network1_id 
 aws ec2 create-security-group --group-name security-group --description "creating security group for instances" --vpc-id $vpc_id 
 security_groups=$(aws ec2 describe-security-groups --query 'SecurityGroups[0].GroupId' --output text) 
 aws ec2 authorize-security-group-ingress --group-id $security_groups --protocol tcp --port 22 --cidr 0.0.0.0/0 
 aws ec2 create-key-pair --key-name lab2-key --query 'KeyMaterial' --output text > lab2-key.pem 
 chmod 400 lab2-key.pem 
 aws ec2 run-instances --image-id ami-0a261c0e5f51090b1 --instance-type t2.micro --count 1 --subnet-id $network1_id \
 --security-group-ids $security_groups --associate-public-ip-address --key-name lab2-key 
 instance_id=$(aws ec2 describe-instances --instance-ids --query 'Reservations[0].Instances[0].InstanceId' --output text) 
 aws ec2 modify-vpc-attribute --enable-dns-hostnames --vpc-id $vpc_id 
 user=$(aws ec2 describe-instances --instance-ids $instance_id --query 'Reservations[].Instances[].PublicDnsName' --output text) 
 echo ssh -i "lab2-key.pem" ec2-user@$user