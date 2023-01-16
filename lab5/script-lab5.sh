#!/bin/bash

topic_arn=$(aws sns create-topic --name load_balancer_health --query 'TopicArn' --output text)
subscribe_arn=$(aws sns subscribe --topic-arn $topic_arn --protocol email --notification-endpoint natalia19022002@gmail.com --query 'SubscriptionArn' --output text)
aws cloudwatch put-metric-alarm --alarm-name WARNalarm --alarm-description "Instance in target group is deleted" --metric-name HealthyHostCount \
--namespace AWS/ApplicationELB --statistic Average --period 10 --threshold 1 --comparison-operator LessThanThreshold --dimensions \
Name=TargetGroup,Value=targetgroup/lab4-tg/274e4b548d06b20d Name=LoadBalancer,Value=app/lab4-lb/f10804edc8ff41da --evaluation-periods 1 --alarm-actions $topic_arn --insufficient-data-actions $topic_arn
echo "Done"
