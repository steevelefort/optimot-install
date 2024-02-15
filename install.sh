#!/bin/sh

VERSION=18
INSTALLZIP=install_xkb.zip

if [ "$(id -u)" = "0" ]; then 
  echo "Installation du pilote Optimot Linux"; 

  # Vérification de la présence de curl
  if ! command -v curl &> /dev/null; then
      echo "curl n'est pas installé. Veuillez l'installer pour continuer."
      exit 1
  fi

  # Vérification de la présence de unzip
  if ! command -v unzip &> /dev/null; then
      echo "unzip n'est pas installé. Veuillez l'installer pour continuer."
      exit 1
  fi

  # Vérification de la présence de python3
  if ! command -v python3 &> /dev/null; then
      echo "python3 n'est pas installé. Veuillez l'installer pour continuer."
      exit 1
  fi

  TARGET=""

  while true; do
      echo "Appuyez sur 1 pour ISO et sur 2 pour Ergo."
      read -r -p "Entrez votre target : " choice

      case $choice in
          1)
              TARGET="ISO"
              break
              ;;
          2)
              TARGET="Ergo"
              break
              ;;
          *)
              echo "Choix invalide. Veuillez entrer 1 ou 2."
              ;;
      esac
  done

  echo "Installation de la version $TARGET en cours ..."

  if [ ! -d "/tmp" ]; then
    mkdir /tmp
  fi
  TMP=/tmp/optimot
  mkdir $TMP 
  rm -rf $TMP/*

  curl -o $TMP/$INSTALLZIP https://optimot.fr/downloads/tools/$INSTALLZIP
  if [ ! -e "$TMP/$INSTALLZIP" ] || [ ! -s "$TMP/$INSTALLZIP" ]; then
    echo "Impossible de télécharger le script d'installation."
    exit 1
  fi

  DRIVER=Optimot_Linux_$TARGET\_$VERSION.zip
  URL="https://optimot.fr/downloads/Optimot_1.8/linux/$DRIVER"
  curl -o $TMP/$DRIVER $URL 
  if [ ! -e "$TMP/$DRIVER" ] || [ ! -s "$TMP/$DRIVER" ]; then
    echo "Impossible de télécharger le pilote."
    exit 1
  fi

  unzip -j $TMP/$INSTALLZIP -d $TMP 
  unzip -j $TMP/$DRIVER -d $TMP

  XKB=`ls -1 $TMP/*.xkb | head -n1`
  XCOMPOSE=`ls -1 $TMP/*.XCompose | head -n1`

  python3 $TMP/install_xkb.py $XKB $XCOMPOSE

else 
  echo "Veuillez lancer cette commande avec des droits super utilisateur (sudo)"; 
fi

