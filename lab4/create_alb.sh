  #!/bin/bash
  
chmod 400 lab3-key.pem
VPC_ID=$(aws ec2 describe-vpcs --query 'Vpcs[0].VpcId' --output text) 
SUBNET1_ID=$(aws ec2 describe-subnets --query 'Subnets[0].SubnetId' --output text) 
SUBNET2_ID=$(aws ec2 describe-subnets --query 'Subnets[-1].SubnetId' --output text) 
SUBNET_IDS=$(aws ec2 describe-subnets --query 'Subnets[*].SubnetId' --output text)
SG=$(aws ec2 describe-security-groups --query 'SecurityGroups[-1].GroupId' --output text)
NEW_SG=$(aws ec2 describe-security-groups --query 'SecurityGroups[-3].GroupId' --output text)
LB_ARN=$(aws elbv2 create-load-balancer --name lab4-lb --subnets $SUBNET_IDS --security-group $SG --query 'LoadBalancers[*].LoadBalancerArn' --output text)
TG_ARN=$(aws elbv2 create-target-group --name lab4-tg --protocol HTTP --port 80 --vpc-id $VPC_ID --query 'TargetGroups[*].TargetGroupArn' --output text) 
IMAGE_ID=$(aws ec2 describe-images --owners 580388863706 --query 'Images[0].ImageId' --output text) 
I1_ID=$(aws ec2 run-instances --image-id $IMAGE_ID --count 1 --instance-type t2.micro --key-name lab3-key --security-group-ids $SG --subnet-id $SUBNET1_ID --user-data file://user_data.sh --query 'Instances[-1].[InstanceId]' --output text) 
I2_ID=$(aws ec2 run-instances --image-id $IMAGE_ID --count 1 --instance-type t2.micro --key-name lab3-key --security-group-ids $SG --subnet-id $SUBNET2_ID --user-data file://user_data.sh --query 'Instances[-1].[InstanceId]' --output text)
echo $SG
echo $IMAGE_ID
echo $I1_ID
echo $I2_ID