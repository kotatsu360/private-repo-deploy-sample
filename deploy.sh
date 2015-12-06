#!/bin/bash

# [NOTE] Accept SSH from Container at CircleCI to AWS temporary.
MYIP=`curl -s http://httpbin.org/ip  | grep -oi -e '[0-9]\+\.[0-9]\+\.[0-9]\+\.[0-9]\+'`
TMP_RULE_NUMBER=10000

TARGET_SECURITY_GROUP=$AWS_NAT_SECURITY_GROUP

OLD_INSTANCE_IDS=`aws ec2 describe-instances --filters "Name=tag:Name,Values=test" | grep -e InstanceId  | grep -oe 'i-[0-9a-z]\+'`

aws ec2 authorize-security-group-ingress --group-id $TARGET_SECURITY_GROUP --protocol tcp --port 22 --cidr $MYIP/32
vagrant up --provider=aws

if [ $? -ne 0 ]; then
    echo 'fail'
    # [NOTE] Delete accept SSH rule
    aws ec2 revoke-security-group-ingress --group-id $TARGET_SECURITY_GROUP --protocol tcp --port 22 --cidr $MYIP/32    
    exit 1
fi

echo 'succeed'

# [NOTE] Delete accept SSH rule
aws ec2 revoke-security-group-ingress --group-id $TARGET_SECURITY_GROUP --protocol tcp --port 22 --cidr $MYIP/32

# [NOTE] Delete old instance
aws ec2 terminate-instances --instance-ids $OLD_INSTANCE_IDS

