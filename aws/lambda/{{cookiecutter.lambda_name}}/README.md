## {{cookiecutter.lambda_name}}

#### How to test lambda locally
In order to test your lambda locally you have to follow the instructions below:

**update the .env file under _docker/.env_**

Add your AWS Credentials and/or all environment variables you will add to your deployed lambda function.

AWS Credentials are necessary if you are going to connect to other AWS service, so be sure to have the right permissions on that Credentials.

**Build the docker image**
```bash
docker build -t awslambda -f ./docker/Dockerfile .
```
or in your root folder using the Makefile

```bash
make build
```

**Run the docker container**
```bash
docker run --env-file ./docker/.env -p 9000:8080 awslambda
```
or in your root folder using the Makefile

```bash
make run
```

**Testing the lambda**

```bash
curl -XPOST "http://localhost:9000/2015-03-31/functions/function/invocations" -d '{}'
```
where **-d '{}'** is your event payload.

For more information about Testing Lambda into container image: https://docs.aws.amazon.com/lambda/latest/dg/images-test.html