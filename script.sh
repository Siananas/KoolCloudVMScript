#!/bin/bash

# Vérification des droits root
if [ "$EUID" -ne 0 ]; then
  echo "Ce script doit être exécuté avec des privilèges root (sudo)." 
  exit 1
fi

# Résolution de dpkg interrompu
echo "Vérification des interruptions de dpkg..."
sudo dpkg --configure -a

# Mise à jour du système
echo "Mise à jour du système..."
sudo apt update && sudo apt upgrade -y

# Installation des dépendances pour Docker
echo "Installation des dépendances..."
sudo apt install -y apt-transport-https ca-certificates curl software-properties-common

# Ajout de la clé GPG officielle de Docker
echo "Ajout de la clé GPG officielle de Docker..."
curl -fsSL https://download.docker.com/linux/ubuntu/gpg | sudo gpg --dearmor -o /usr/share/keyrings/docker-archive-keyring.gpg

# Ajout du dépôt Docker
echo "Ajout du dépôt Docker..."
echo "deb [arch=$(dpkg --print-architecture) signed-by=/usr/share/keyrings/docker-archive-keyring.gpg] https://download.docker.com/linux/ubuntu $(lsb_release -cs) stable" | sudo tee /etc/apt/sources.list.d/docker.list > /dev/null

# Mise à jour de la liste des paquets
echo "Mise à jour de la liste des paquets..."
sudo apt update

# Installation de Docker
echo "Installation de Docker..."
sudo apt install -y docker-ce docker-ce-cli containerd.io

# Vérification de l'installation
if ! command -v docker &> /dev/null; then
  echo "Docker n'a pas été correctement installé. Vérifiez les journaux et réessayez."
  exit 1
fi

# Création du groupe Docker s'il n'existe pas
if ! getent group docker > /dev/null; then
  echo "Création du groupe Docker..."
  sudo groupadd docker
fi

# Ajout de l'utilisateur actuel au groupe Docker
echo "Ajout de l'utilisateur actuel au groupe Docker..."
sudo usermod -aG docker $USER

# Démarrage et activation de Docker
echo "Démarrage et activation de Docker..."
sudo systemctl start docker
sudo systemctl enable docker

# Vérification du démarrage de Docker
if ! systemctl is-active --quiet docker; then
  echo "Docker n'a pas pu démarrer correctement. Vérifiez les journaux et réessayez."
  exit 1
fi

# Téléchargement et exécution d'un conteneur de test (Doom)
echo "Téléchargement et exécution d'un conteneur Docker..."
sudo docker run --rm -it --shm-size=512m -p 6901:6901 -e VNC_PW=password kasmweb/doom:1.16.0

# Message de fin
echo "Installation et exécution terminées ! Vous pouvez accéder à votre conteneur Doom sur http://localhost"
