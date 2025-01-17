#!/bin/bash -eu

#                 dockerhub_image               tag
# usage: build.sh yakumosaki/fastladder-aarch64 20250130
#
# This will build docker image 
# and tagging with $2 and latest

set +u

BASE_DIR=`pwd`
BUILD_DIR="$BASE_DIR/build"

#
DOCKERHUB_IMAGE="$1"
#VERSION=`LANG=C date '+%Y%m%d%H'`
VERSION=$2

ORIGIN_URL="https://github.com/fastladder/fastladder.git"

# start build
set -u

if [[ -z $DOCKERHUB_IMAGE ]]; then
    echo 'Dockerhubイメージ名が指定されていません。'
    exit 1
fi

if [[ -z $VERSION ]]; then
    echo 'タグ名が指定されていません。'
    exit 1
fi

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
cd $BASE_DIR
docker build  --progress=plain -t $DOCKERHUB_IMAGE:$VERSION .
docker tag $DOCKERHUB_IMAGE:$VERSION $DOCKERHUB_IMAGE:latest

echo "### PREPARE SUCCESS ###"
