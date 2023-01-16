#!/bin/bash

topics_arn=$(aws sns list-topics --query 'Topics[*].TopicArn' --output text)
alarm_name=$(aws cloudwatch describe-alarms --query 'MetricAlarms[*].AlarmName' --output text)
aws sns delete-topic --topic-arn $topics_arn
aws cloudwatch delete-alarms --alarm-names $alarm_name
echo "Done"
