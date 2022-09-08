#!/bin/bash

bold=$(tput bold)
underline=$(tput smul)
italic=$(tput sitm)
info=$(tput setaf 2)
error=$(tput setaf 160)
warn=$(tput setaf 214)
reset=$(tput sgr0)

filename=$(basename -- "{{ cookiecutter.handler_file }}")
extension="${filename##*.}"

if [ "$extension" == "py" ];
then
echo " ${info}INFO: ${reset}Creating the file code/{{cookiecutter.handler_file}}${reset}"
cat << EOF > code/{{cookiecutter.handler_file}}
import json

def lambda_handler(event, context):
    #TODO implement
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }
EOF

echo " ${info}INFO: ${reset}Creating file code/requirements.txt${reset}"
touch "code/requirements.txt"
fi

if [ {{ cookiecutter.create_lambda_layer }} == "y" ];
then
    echo ${info}INFO: ${reset}Creating layer folder${reset}
    mkdir ./layer
    echo "${info}INFO: ${reset}Layer folder created!${reset}"
    echo "Remember to save all modules under the layer folder using ${bold}pip install --target=<path-to>/layer/ -r <path-to>/requirements.txt ${reset}before upload to AWS${reset}"
fi

if [ {{ cookiecutter.create_local_virtualenv }} == "y" ];
then
    echo "${info}INFO: ${reset}Creating virtual environment...${reset}"
    python3 -m venv venv
    echo "${info}INFO: ${reset}Virtual environment created!${reset}"
fi