#!/bin/bash 

instance_id=$(aws ec2 describe-instances --filters Name=instance-state-name,Values=stopped Name=instance-type,Values=t2.micro --query 'Reservations[*].Instances[].InstanceId' --output text)
echo $instance_id

image_id=$(aws ec2 create-image --instance-id $instance_id --name 'AMI-lab3' --description 'An AMI for WebServer' --query ImageId --output text)
echo $image_id