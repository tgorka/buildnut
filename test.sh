#!/usr/bin/env zsh

## List Docker CLI commands
#docker
#docker container --help

## Display Docker version and info
#docker --version
#docker version
docker info

## List Docker images
#docker pull tgorka/buildnut:latest
#docker build .
#docker tag tgorka/buildnut:latest buildnut:latest
docker image ls

## List Docker containers (running, all, all in quiet mode)
#docker container ls
docker container ls --all
#docker container ls -aq

## Execute Docker image
#docker run -it tgorka/buildnut
#docker run -d -p 4000:80 tgorka/buildnut
#docker stop tgorka:buildnut
