#!/bin/bash -eu

BASE_DIR=`pwd`
BUILD_DIR="$BASE_DIR/build"

#
DOCKERHUB_IMAGE="yakumosaki/fastladder"
VERSION=`LANG=C date '+%Y%m%d%H'`

if [ ! -d "${BUILD_DIR}" ]; then
  echo "no build directory. 'git clone repositoryurl build' first." 
  exit 1
fi

# config
cat $BUILD_DIR/Gemfile \
  | sed s/"gem 'mysql2'"/"gem 'mysql2', '< 0.5.0'"/ \
  | sed s/"gem 'pg'"/"gem 'pg', '~> 0.15'"/ > $BUILD_DIR/Gemfile.new

mv $BUILD_DIR/Gemfile.new $BUILD_DIR/Gemfile

echo "### PREPARE SUCCESS ###"
