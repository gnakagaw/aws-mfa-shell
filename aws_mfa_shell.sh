#!/bin/bash

# paramters
REGION="us-east-1"

# PHASE 1: get MFA device code
RESULT=`aws iam list-mfa-devices 2>&1`

if [ $? -ne 0 ]; then
    cat <<EOS
Failed to get MFA device ARN code. Abort.
Please check your MFA device settings on https://console.aws.amazon.com/iam/home#security_credentials

message from aws-cli:
EOS
    echo ${RESULT}
    exit
fi

MFA_SERIAL_NUMBER=`echo ${RESULT} | jq -r .MFADevices[0].SerialNumber`

# PHASE 2: get temporary security credential
echo -n "MFA code? "
read MFA_CODE

RESULT=`aws sts get-session-token --serial-number ${MFA_SERIAL_NUMBER} --token-code ${MFA_CODE} --region ${REGION} 2>&1`
if [ $? -ne 0 ]; then
    cat <<EOS
Failed to get temporary access credentials. Abort.

message from aws-cli:
EOS
    echo ${RESULT}
    exit
fi

# PHASE 3: run a new shell with temporary credentials
export AWS_ACCESS_KEY_ID=`echo $RESULT | jq -r .Credentials.AccessKeyId`
export AWS_SECRET_ACCESS_KEY=`echo $RESULT | jq -r .Credentials.SecretAccessKey`
export AWS_SESSION_TOKEN=`echo $RESULT | jq -r .Credentials.SessionToken`
export AWS_DEFAULT_REGION=${REGION}

bash
