#!/bin/bash

aws s3api create-bucket --bucket lab1np11111 --region us-east-1 \
  && aws s3api put-bucket-policy --bucket lab1np11111 --policy file://policyl1.json \
  && aws s3 sync ./ s3://lab1np11111/ \
  && aws s3 website s3://lab1np11111/ --index-document index.html --error-document error.html \
  && aws s3 presign s3://lab1np11111/index.html