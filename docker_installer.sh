#!/usr/bin/env bash

install_docker(){
  sudo apt-get remove -y docker docker-engine docker.io containerd runc
  sudo apt-get update
  sudo apt-get install -y apt-transport-https ca-certificates curl gnupg-agent software-properties-common
  curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo apt-key add -
  sudo apt-key fingerprint 0EBFCD88
  sudo add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable"
  sudo apt-get update
  sudo apt-get install -y docker-ce docker-ce-cli containerd.io
}

install_docker_compose(){
  curl -O https://raw.githubusercontent.com/frkhit/file_servers/master/run.sh && sudo chmod +x run.sh
  sudo mv run.sh /usr/local/bin/docker-compose
}

# install docker
install_docker

# install docker-compose
install_docker_compose

