# Flask Hello (color via env, single image)

Tiny Flask app that prints a message in any color using env vars.

## Run from Docker Hub
```bash
docker run -d -p 8081:5000 -e TEXT_COLOR=green -e HELLO_MSG="Hello World" rsiddapp/flask-hello:latest
docker run -d -p 8082:5000 -e TEXT_COLOR=red   -e HELLO_MSG="Namaste Raghu" rsiddapp/flask-hello:latest

## Build locally
```
docker build -t flask-hello .
docker run -d -p 5001:5000 -e TEXT_COLOR=green -e HELLO_MSG="Hello World" flask-hello

### Compose (local build)
docker compose -f docker-compose.yaml up -d

## Compose (pull from Hub)
docker compose -f compose.hub.yaml up -d

## Env vars

TEXT_COLOR – any CSS color (e.g., green, #ff0000)

HELLO_MSG – text to display

## Note: Save YAML files as UTF-8, not UTF-16. No emoji/smart quotes.
