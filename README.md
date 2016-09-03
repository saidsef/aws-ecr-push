# AWS ECR Push

This script will build a Dockerfile in the root directory and then will push the resulting container into AWS ECR.

## Prerequisite

For this script to run successfully, you will need:
 * Amazon AWS Account
 * AWS EC2 Instance with IAM Role*
 * AWS CLI
 * Docker

### IAM Role
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
## Usage

Place a Dockerfile in the root directory and then run the following command:

```
./ecr-push.sh <repository> <tag>
```
