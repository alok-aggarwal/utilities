#!/bin/bash

echo "deb http://pkg.scaleft.com/deb linux main" | sudo tee -a /etc/apt/sources.list
curl -fsSL https://dist.scaleft.com/pki/scaleft_deb_key.asc | gpg --dearmor | sudo tee /usr/share/keyrings/scaleft-archive-keyring.gpg > /dev/null
sudo apt-get update -y
sudo apt-get install scaleft-client-tools -y
sudo apt-get install scaleft-url-handler -y


#note: install scaleft was failing coz my ubuntu didn;t have the public key for scaleft, so added the key like this
#sudo apt-key adv --keyserver keyserver.ubuntu.com --recv-keys F716E939977FC428

