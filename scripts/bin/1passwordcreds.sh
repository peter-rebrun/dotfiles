#!/bin/bash

# Get your AWS access key ID and secret access key from 1Password
AWS_ACCESS_KEY_ID=$(op read "op://Private/AWS CLI Access Key/access key id")
AWS_SECRET_ACCESS_KEY=$(op read "op://Private/AWS CLI Access Key/secret access key")
TFE_TOKEN=$(op read "op://Private/HashiCorp/token")
NODE_AUTH_TOKEN=$(op read "op://Private/NodeToken/credential") 

# Export the AWS credentials as environment variables
export AWS_ACCESS_KEY_ID
export AWS_SECRET_ACCESS_KEY
export TFE_TOKEN
export NODE_AUTH_TOKEN
