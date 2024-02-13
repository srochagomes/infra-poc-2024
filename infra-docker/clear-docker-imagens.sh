#!/bin/bash

sudo docker-compose down
sudo docker stop $(docker ps -a -q)
sudo docker container prune -f
# Limpa todas as imagens Docker
sudo docker image prune -a --force

sudo docker rm $(docker ps -a -q)

sudo docker rmi $(docker images -a -q)
