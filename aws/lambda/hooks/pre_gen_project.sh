#!/bin/bash

bold=$(tput bold)
underline=$(tput smul)
italic=$(tput sitm)
info=$(tput setaf 2)
error=$(tput setaf 160)
warn=$(tput setaf 214)
reset=$(tput sgr0)

if [ {{ cookiecutter.create_lambda_layer }} == "Yes" ];
then
    echo ${info}INFO: ${reset}Creating layer folder${reset}
    mkdir ./layer
    echo "${info}INFO: ${reset}Layer folder created!${reset}"
    echo "Remember to save all modules under the layer folder using ${bold}pip install --target=<path-to>/layer/ -r <path-to>/requirements.txt ${reset}before upload to AWS${reset}"
fi

if [ {{ cookiecutter.create_local_virtualenv }} == "Yes" ];
then
    echo "${info}INFO: ${reset}Creating virtual environment...${reset}"
    python3 -m venv venv
    echo "${info}INFO: ${reset}Virtual environment created!${reset}"
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

    # creating a dummy file to be zipped becuase it is not possible upload an empty zip
    cat<<EOF >code/dummy.txt
    this is a dummy file created because you cannot upload an empty zip
    EOF

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