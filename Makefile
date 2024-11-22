init-tmp-container:
	@docker container run -it --rm --name app -v $$(pwd):/app -w /app python:3.12.5-alpine3.20 ash

py-reqs:
	@pip freeze > ./requirements.txt

py-server:
	@/home/py/.local/bin/flask --app src/main --env-file .env --debug run --reload --host 0.0.0.0 --port 3000

py-server-prod:
	@/home/py/.local/bin/flask --app src/main run --host 0.0.0.0 --port 3000
	
backend-exec:
	@docker container exec -it backend bash

backend-run:
	@docker container exec -it backend bash -c "python main.py"

up:
	@docker compose up -d --build
	
down:
	@docker compose down

ps:
	@docker compose ps -a