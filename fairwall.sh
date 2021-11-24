#! /bin/bash

sudo apt install ufw -y
sudo ufw enable -y
sudo ufw allow 4242
sudo ufw status
