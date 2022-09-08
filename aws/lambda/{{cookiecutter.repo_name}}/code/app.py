#----------------------------------------------------------------------------
# Created By: {{ cookiecutter.author }}
# Email: {{ cookiecutter.email }}
# Created Date: {% now 'local', '%d/%m/%Y' %}
# version: {{ cookiecutter.version }}
# ---------------------------------------------------------------------------
""" {{ cookiecutter.short_description }} """
# ---------------------------------------------------------------------------
# Imports Line 5
# ---------------------------------------------------------------------------

import json

def lambda_handler(event, context):
    #TODO implement
    return {
        'statusCode': 200,
        'body': json.dumps('Hello from Lambda!')
    }