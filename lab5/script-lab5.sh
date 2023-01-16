#!/bin/bash

topic_arn=$(aws sns create-topic --name lb_health --query 'TopicArn' --output text)
subscribe_arn=$(aws sns subscribe --topic-arn $topic_arn --protocol email --notification-endpoint natalia19022002@gmail.com --query 'SubscriptionArn' --output text)
aws cloudwatch put-metric-alarm --alarm-name WARNalarm --alarm-description "Instance in target group is deleted" --metric-name HealthyHostCount \
--namespace AWS/ApplicationELB --statistic Average --period 60 --threshold 2 --comparison-operator LessThanThreshold --dimensions \
Name=TargetGroup,Value=targetgroup/lab4-tg/4ab6f5a1254ea003 Name=LoadBalancer,Value=app/lab4-lb/885759b40d8cf99c --evaluation-periods 1 --alarm-actions $topic_arn --insufficient-data-actions $topic_arn
echo "Done"
