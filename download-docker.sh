#!/bin/bash
# Ensure the script is run as root
if [ "$(id -u)" != "0" ]; then
   echo "This script must be run as root" 1>&2
   exit 1
fi
# Step 1: Update package database
apt-get update
# Step 2: Install prerequisites
apt-get install -y apt-transport-https ca-certificates curl software-properties$
# Step 3: Add Docker's official GPG key
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | apt-key add -
# Step 4: Add Docker's repository
add-apt-repository "deb [arch=amd64] https://download.docker.com/linux/ubuntu $$
# Step 5: Install Docker
apt-get install -y docker-ce docker-ce-cli containerd.io
# Step 6: Start Docker and enable it at boot
systemctl start docker
systemctl enable docker
# Step 7: Add current user to Docker group
usermod -aG docker $USERecho "Docker installation complete."

sudo docker run --rm -it --shm-size=512m -p 6901:6901 -e VNC_PW=password kasmwe$
