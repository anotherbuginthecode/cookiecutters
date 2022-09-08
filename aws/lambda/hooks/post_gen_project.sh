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

if [ {{ cookiecutter.cicd_github_action }} == "N" ];
then
    rm -rf .github/
if

if [ {{ cookiecutter.git_init }} == "y" ];
then
    git init
    git add .
    git commit -m "First commit"
if

echo ""
echo ""
echo "Enjoy your project and remember to ${bold}Praise the sun! \[T]/ ${reset}"