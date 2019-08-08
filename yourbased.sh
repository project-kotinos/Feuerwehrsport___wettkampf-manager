#!/usr/bin/env bash
set -ex
export DEBIAN_FRONTEND=noninteractive
apt-get update && apt-get install -y tzdata xvfb
gem install bundler -v 2.0.1
# before_install
sed -i 's/git@github.com:/https:\/\/github.com\//' .gitmodules
git submodule update --init --recursive
# install
bundle install --jobs=3 --retry=3
# script
xvfb-run bundle exec rspec
