#!/bin/bash
#This simple scripts is getting secret values from AWS Secret manager, pasrses username and passord keys and generates .my.cnf file
#Environment Staging

file_location=~/.my.cnf
aws_region=us-west-1
secretid='rds!db-c7dea578-ba18-4077-a686-6fd78eca2e9c'
host=staging-mysql.stackla.aws
username=$(aws secretsmanager get-secret-value --secret-id --region=$aws_region $secretid| jq --raw-output '.SecretString' | jq -r .username)
password=$(aws secretsmanager get-secret-value --secret-id --region=$aws_region $secretid| jq --raw-output '.SecretString' | jq -r .password)

cat > $file_location <<EOF
[mysql]
host=$host
user=$username
password='$password'

[mysqldump]
host=$host
user=$username
password='$password'
EOF

