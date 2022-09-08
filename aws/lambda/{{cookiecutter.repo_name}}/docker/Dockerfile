FROM public.ecr.aws/lambda/{{cookiecutter.runtime}}

COPY ../code/requirements.txt .
RUN pip install --no-cache-dir -r requirements.txt --target "${LAMBDA_TASK_ROOT}"
# Copy function conde
COPY ./code/ ${LAMBDA_TASK_ROOT}

# Set the CMD to your handler (could also be done as a parameter override outside of the Dockerfile)
CMD [ "app.lambda_handler" ]