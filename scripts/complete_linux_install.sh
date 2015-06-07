#!/bin/bash

sudo apt-get update
sudo apt-get -y install firefox libreoffice openssh-server htop vim nginx git g++ gcc make libc6-dev libreadline6-dev zlib1g-dev libssl-dev libyaml-dev libsqlite3-dev sqlite3 autoconf libgdbm-dev libncurses5-dev automake libtool bison pkg-config libffi-dev nodejs
sudo bash -c "echo 'server { listen 80 default_server; listen [::]:80 default_server ipv6only=on; location / { proxy_pass http://localhost:3000; } }' > /etc/nginx/sites-enabled/default"
sudo service nginx restart

# rvm
gpg --keyserver hkp://keys.gnupg.net --recv-keys 409B6B1796C275462A1703113804BB82D39DC0E3
\curl -sSL https://get.rvm.io | bash -s stable
echo 'export PATH="$PATH:$HOME/.rvm/bin" # Add RVM to PATH for scripting' >> ~/.bashrc
echo 'source /home/user/.rvm/scripts/rvm' >> ~/.bashrc
export PATH="$PATH:$HOME/.rvm/bin"
source /home/user/.rvm/scripts/rvm

# source
if [[ ! -d ~/wettkampf-manager ]] ; then
  git clone https://github.com/Feuerwehrsport/wettkampf-manager
fi
cd wettkampf-manager

rvm install ruby-2.1.0
rvm current
cd ..
cd wettkampf-manager
rvm current
gem install bundler
bundle
./scripts/install.rb
./scripts/start_server.sh

read -p "Press any key"