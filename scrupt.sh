#!/bin/bash

apt update docker
snap install docker

sudo docker run --rm -it --shm-size=512m -p 6901:6901 -e VNC_PW=password kasmweb/doom:1.16.0
