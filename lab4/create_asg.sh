#!/bin/bash

load_balancer_arn=$(aws elbv2 describe-load-balancers --query 'LoadBalancers[*].LoadBalancerArn' --output text)
target_group_arn=$(aws elbv2 describe-target-groups --query 'TargetGroups[*].TargetGroupArn' --output text)
echo $load_balancer_arn
echo $target_group_arn
instance1_id=$(aws ec2 describe-instances --query 'Reservations[-1].Instances[*].[InstanceId]' --filters Name=instance-state-name,Values=running --output text)
instance2_id=$(aws ec2 describe-instances --query 'Reservations[-2].Instances[*].[InstanceId]' --filters Name=instance-state-name,Values=running --output text)
echo $instance1_id
echo $instance2_id
aws elbv2 register-targets --target-group-arn $target_group_arn --targets Id=$instance1_id Id=$instance2_id
aws elbv2 create-listener --load-balancer-arn $load_balancer_arn --protocol HTTP --port 80 --default-actions Type=forward,TargetGroupArn=$target_group_arn 
aws elbv2 describe-target-health --target-group-arn $target_group_arn 
aws autoscaling create-auto-scaling-group --auto-scaling-group-name lab4-asg --instance-id $instance1_id --min-size 2 --max-size 2 --target-group-arns $target_group_arn 
aws autoscaling describe-load-balancer-target-groups --auto-scaling-group-name lab4-asg
aws autoscaling update-auto-scaling-group --auto-scaling-group-name lab4-asg --health-check-type ELB --health-check-grace-period 15 
load_balancer_dns=$(aws elbv2 describe-load-balancers --query 'LoadBalancers[0].DNSName' --output text)
aws autoscaling describe-auto-scaling-groups --auto-scaling-group-name lab4-asg
echo $load_balancer_dns
