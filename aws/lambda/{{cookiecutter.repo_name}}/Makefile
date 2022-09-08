build:
	docker build -t awslambda -f ./docker/Dockerfile .
run:
	docker run --env-file ./docker/.env -p 9000:8080 awslambda