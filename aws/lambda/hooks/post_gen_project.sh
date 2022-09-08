#!/bin/bash

bold=$(tput bold)
info=$(tput setaf 2)
reset=$(tput sgr0)

filename=$(basename -- "{{ cookiecutter.handler_file }}")
extension="${filename##*.}"

if [ "$extension" == "py" ];
then
echo "${info}INFO: ${reset}Creating the file code/{{cookiecutter.handler_file}}${reset}"
cat << EOF > code/{{cookiecutter.handler_file}}
import json

def lambda_handler(event, context):
    #TODO implement
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
EOF

echo "${info}INFO: ${reset}Creating file code/requirements.txt${reset}"
touch "code/requirements.txt"
fi

cat << EOF > docker/.env
AWS_ACCESS_KEY_ID=
AWS_SECRET_ACCESS_KEY=
AWS_REGION=
AWS_LAMBDA_FUNCTION_TIMEOUT=5
AWS_LAMBDA_FUNCTION_MEMORY_SIZE=128
EOF

if [ {{ cookiecutter.cicd_github_action }} == "N" ];
then
    rm -rf .github/
fi

if [ {{ cookiecutter.git_init }} == "y" ];
then
    git init
    git add .
    git commit -m "First commit"
fi

if [ {{ cookiecutter.auto_lambda_creation }} == "Yes" ];
then

# pre-process
RUNTIME="$(echo "{{cookiecutter.runtime}}" | sed 's/://g')"
filename=$(basename -- "{{ cookiecutter.handler_file }}")
extension="${filename##*.}"
filename="${filename%.*}"

echo "${info}INFO: ${reset}check if aws credentials are configured..."
is_valid="$(aws iam get-user)"
if [ $? -eq 0 ];
then
        echo "correct."
fi

cat <<EOF >trust-policy.json
{
"Version": "2012-10-17",
"Statement": [
    {
    "Effect": "Allow",
    "Principal": {
        "Service": "lambda.amazonaws.com"
    },
    "Action": "sts:AssumeRole"
    }
]
}
EOF

echo "${info}INFO: ${reset}Creating IAM role..."
echo "${warn}NB: ${reset}copy and paste the 'role arn' into a notepad"
aws_role="$(aws iam create-role --role-name {{cookiecutter.lambda_name}}-role --assume-role-policy-document file://trust-policy.json)"
aws iam attach-role-policy --role-name {{cookiecutter.lambda_name}}-role --policy-arn arn:aws:iam::aws:policy/service-role/AWSLambdaBasicExecutionRole
echo $aws_role

echo "${info}INFO: ${reset}Creating the lambda function..."
(cd code && zip -r9 ../lambda.zip . &>/dev/null)
rm code/dummy.txt

read -p "role arn: " LAMBDA_ROLE_ARN
function="$(aws lambda create-function --function-name {{cookiecutter.lambda_name}} --runtime ${RUNTIME} --zip-file fileb://lambda.zip --handler ${filename}.lambda_handler --role "${LAMBDA_ROLE_ARN}")"
rm trust-policy.json
if [ $? -eq 0 ];
then
    echo "${info}INFO: ${reset}Lambda created correctly on AWS"
fi


fi

echo ""
echo ""
echo "Enjoy your project and remember to ${bold}Praise the sun! \[T]/ ${reset}"