  #!/bin/bash
  
chmod 400 lab3-key.pem
vpc_id=$(aws ec2 describe-vpcs --query 'Vpcs[0].VpcId' --output text) 
subnet1_id=$(aws ec2 describe-subnets --query 'Subnets[0].SubnetId' --output text) 
subnet2_id=$(aws ec2 describe-subnets --query 'Subnets[-1].SubnetId' --output text) 
subnet_ids=$(aws ec2 describe-subnets --query 'Subnets[*].SubnetId' --output text)
security_groups=$(aws ec2 describe-security-groups --query 'SecurityGroups[-1].GroupId' --output text)
new_security_groups=$(aws ec2 describe-security-groups --query 'SecurityGroups[-3].GroupId' --output text)
load_balancer_arn=$(aws elbv2 create-load-balancer --name lab4-lb --subnets $subnet_ids --security-group $security_groups --query 'LoadBalancers[*].LoadBalancerArn' --output text)
target_group_arn=$(aws elbv2 create-target-group --name lab4-tg --protocol HTTP --port 80 --vpc-id $vpc_id --query 'TargetGroups[*].TargetGroupArn' --output text) 
image_id=$(aws ec2 describe-images --owners 580388863706 --query 'Images[0].ImageId' --output text) 
instance1_id=$(aws ec2 run-instances --image-id $image_id --count 1 --instance-type t2.micro --key-name \
lab3-key --security-group-ids $security_groups --subnet-id $subnet1_id --user-data file://user_data.sh --query 'Instances[-1].[InstanceId]' --output text) 
instance2_id=$(aws ec2 run-instances --image-id $image_id --count 1 --instance-type t2.micro --key-name \
lab3-key --security-group-ids $security_groups --subnet-id $subnet2_id --user-data file://user_data.sh --query 'Instances[-1].[InstanceId]' --output text)
echo $security_groups
echo $image_id
echo $instance1_id
echo $instance2_id