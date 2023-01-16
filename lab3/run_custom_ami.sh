#!/bin/bash

image_id=$(aws ec2 describe-images --owners 580388863706 --query 'Images[*].ImageId' --output text) 
echo $image_id 
aws ec2 run-instances --image-id $image_id --count 1 --instance-type t2.micro --key-name lab3-key --security-group-ids $security_group --user-data file://user_data.sh