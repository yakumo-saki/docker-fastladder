#!/bin/bash -eu

# prepare.sh 
# pull and some replace 

set +u

BASE_DIR=`pwd`
BUILD_DIR="$BASE_DIR/build"

ORIGIN_URL="https://github.com/fastladder/fastladder.git"

set -u

if [ ! -d "${BUILD_DIR}" ]; then
  git clone --depth=1 ${ORIGIN_URL} build
  echo "build directory not found. Doing shallow clone"
else
  echo "build directory found. Doing reset and pull"
  cd $BUILD_DIR
  git reset --hard
  git pull
fi

echo "Listing directory"
ls -lh


# replace yaml
cd $BASE_DIR
cp database.yml build/config/database.yml
cp secrets.yml build/config/secrets.yml

# build from base Dockerfile
echo "Ready to docker build"
echo "### PREPARE SUCCESS ###"
