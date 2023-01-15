#!/bin/bash

aws s3api create-bucket --bucket my-bucket-lab8 --region us-east-1
aws s3 cp C:/Users/Natalia/Cloud/cl1/CloudComputing2022/lab8/5lab8.jpg s3://my-bucket-lab8/
aws s3 presign s3://my-bucket-lab8/5lab8.jpg