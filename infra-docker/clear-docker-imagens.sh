#!/bin/bash

sudo docker container prune -f
# Limpa todas as imagens Docker
sudo docker image prune -a --force
