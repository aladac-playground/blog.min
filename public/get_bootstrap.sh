#!/bin/bash


if [ -d "./bootstrap" ]; then
  rm -rf ./bootstrap
fi

if [ -f "./bootstrap.zip" ]; then 
  rm -f ./bootstrap.zip
fi

if [ -z `which wget` ]; then
  echo "Missing wget"
  if [ `lsb_release -a 2> /dev/null | grep Distributor  | awk -F":\t" '{print $2}'` == "Ubuntu" ]; then
    echo "install: sudo apt-get install wget"
  fi
  exit
fi

if [ -z `which unzip` ]; then
  echo "Missing unzip"
  if [ `lsb_release -a 2> /dev/null | grep Distributor  | awk -F":\t" '{print $2}'` == "Ubuntu" ]; then
    echo "install: sudo apt-get install unzip"
  fi
  exit
fi

wget "http://twitter.github.com/bootstrap/assets/bootstrap.zip"
unzip "bootstrap.zip"
