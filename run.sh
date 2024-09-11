#!/bin/sh

# blend-comfy
docker build -t blend-comfy:0.1 -f Base.Dockerfile .;docker compose up blend-comfy -d;docker logs -f blend-comfy

exit

# push base (blend-comfy)
docker build -f Base.Dockerfile -t balven/bdkeifk:240905 .
docker push