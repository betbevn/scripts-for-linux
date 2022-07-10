#!/bin/bash

function install_basic_tools() {
   echo "Installing basic tools ..."
   sudo yum -y update
   sudo yum -y install byobu zsh vim
   sudo yum -y install git
   sudo yum -y install htop
   sudo yum -y install wget
   sudo yum -y install net-tools
}

function install_docker_and_tools() {
    echo "Installing Docker..."
    wget -qO- https://get.docker.com/ | sh

    echo "Installing docker-compose..."
    COMPOSE_VERSION=1.25.4
    sudo wget -q https://github.com/docker/compose/releases/download/$COMPOSE_VERSION/docker-compose-`uname -s`-`uname -m` \
        -O /usr/local/bin/docker-compose
    sudo chmod +x /usr/local/bin/docker-compose

    echo "Installing docker-machine..."
    MACHINE_VERSION=0.16.2
    sudo wget -q https://github.com/docker/machine/releases/download/v$MACHINE_VERSION/docker-machine-`uname -s`-`uname -m` \
        -O /tmp/docker-machine
    chmod +x /tmp/docker-machine
    sudo cp /tmp/docker-machine /usr/local/bin/docker-machine

    echo "Installing ctop..."
    CTOP_VERSION=0.7.3
    sudo wget https://github.com/bcicen/ctop/releases/download/v$CTOP_VERSION/ctop-$CTOP_VERSION-linux-amd64 \
        -O /usr/local/bin/ctop
    sudo chmod +x /usr/local/bin/ctop
}

function config_base_user() {
    user=$1

    echo "Install Oh-My-Zsh"
    yes n | sh -c "$(wget -O- https://raw.githubusercontent.com/ohmyzsh/ohmyzsh/master/tools/install.sh)"

    echo "Change shell"
    sudo chsh -s /bin/zsh ${user}

    echo "Add users to docker group"
    sudo usermod -a -G docker ${user}
}


# Variables

USER='root'

# Setup
install_basic_tools

install_docker_and_tools

config_base_user $USER