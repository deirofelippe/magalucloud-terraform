#!/bin/bash

sudo apt update

install_docker(){
  sudo apt install -y ca-certificates curl &&
  sudo install -m 0755 -d /etc/apt/keyrings &&
  sudo curl -fsSL https://download.docker.com/linux/ubuntu/gpg -o /etc/apt/keyrings/docker.asc &&
  sudo chmod a+r /etc/apt/keyrings/docker.asc &&

  # Add the repository to Apt sources:
  echo \
    "deb [arch=$(dpkg --print-architecture) signed-by=/etc/apt/keyrings/docker.asc] https://download.docker.com/linux/ubuntu \
    $(. /etc/os-release && echo "$VERSION_CODENAME") stable" | \
    sudo tee /etc/apt/sources.list.d/docker.list > /dev/null &&

  sudo apt update &&

  sudo apt install -y docker-ce docker-ce-cli containerd.io docker-buildx-plugin docker-compose-plugin &&

  # Verificando se o docker foi instalado corretamente
  sudo docker container run hello-world
}

init_docker_compose(){
    sudo docker compose --file /home/ubuntu/scripts/docker-compose.prod.yaml up -d
}

install_docker
init_docker_compose