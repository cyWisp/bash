#!/bin/bash
 #
 ### Run STS AssumeRole command
 assumeRoleOutput=$(aws sts assume-role --role-arn arn:aws:iam::853697862182:role/HIDS-ADO10-cicd-gha-runner-cloud-bootstrap-dev --role-session-name GitHubActions --duration-seconds 3600)
 ##
 ### Extract the AWS access key, secret key, and session token from the assume-role output
 AWS_ACCESS_KEY_ID=$(echo "$assumeRoleOutput" | grep "AccessKeyId" | cut -d':' -f2 | tr -d '[:space:]')
 AWS_SECRET_ACCESS_KEY=$(echo "$assumeRoleOutput" | grep "SecretAccessKey" | cut -d':' -f2 | tr -d '[:space:]')
 AWS_SESSION_TOKEN=$(echo "$assumeRoleOutput" | grep "SessionToken" | cut -d':' -f2 | tr -d '[:space:]')
 ##
 ### Print out the export statements
 echo "export AWS_ACCESS_KEY_ID=$AWS_ACCESS_KEY_ID" | sed 's/,//g'
 echo "export AWS_SECRET_ACCESS_KEY=$AWS_SECRET_ACCESS_KEY" | sed 's/,//g'
 echo "export AWS_SESSION_TOKEN=$AWS_SESSION_TOKEN" | sed 's/,//g