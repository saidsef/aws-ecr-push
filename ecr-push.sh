#!/usr/bin/env bash

set -ex

if [ $# -lt 2 ]; then
	echo "I need path and tag to complete successfully"
	exit 1
fi

function usage {
    echo '''
    
    Looks like permissions issue, try updating the IAM Role*:
    ```
    {
        "Version": "2012-10-17",
        "Statement": [
            {
                "Effect": "Allow",
                "Action": [
                    "ecr:GetAuthorizationToken",
                    "ecr:InitiateLayerUpload",
                    "ecr:UploadLayerPart",
                    "ecr:CompleteLayerUpload",
                    "ecr:BatchCheckLayerAvailability",
                    "ecr:PutImage"
                ],
                "Resource": "*"
            }
        ]
    }
    
    ```
    By default ECR repositories do not have a policy. Once that's created and includes the permissions needed the issue should be resolved.
    
    '''
    exit 1
}

export REGION=${REGION:-$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq .region -r)}
export ACCOUNT_ID=${ACCOUNT_ID:-$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq .accountId -r)}
export AVAILABILITY_ZONE=${AVAILABILITY_ZONE:-$(curl -s http://169.254.169.254/latest/dynamic/instance-identity/document | jq .availabilityZone -r)}
export REPOSITORY_NAME=$1
export TAG=$2

if aws ecr get-login --region $REGION ; then

aws ecr create-repository --repository-name $REPOSITORY_NAME --region $REGION
aws ecr get-login --region $REGION | xargs -i -t sh -c '{}'

docker build -t $REPOSITORY_NAME .
docker tag $REPOSITORY_NAME $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPOSITORY_NAME:$TAG
docker push $ACCOUNT_ID.dkr.ecr.$REGION.amazonaws.com/$REPOSITORY_NAME:$TAG

aws ecr describe-repositories --region $REGION | jq .repositories -r | grep "$REPOSITORY_NAME"

else

usage

fi
