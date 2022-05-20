#!/bin/bash
#
# Copyright (c) 2021 - for information on the respective copyright owner
# see the NOTICE file and/or the repository https://github.com/carbynestack/base-images.
#
# SPDX-License-Identifier: Apache-2.0
#


REPOSITORY="ghcr.io/carbynestack"
VERSION="0.4"

buildImage() {
  docker build -f ${1} . --build-arg VERSION=${VERSION} -t ${REPOSITORY}/${2}:${3}
}

while [ $# -gt 0 -a "$1" != "" ]; do
  case $1 in
  -v | --version)
    VERSION="$2"
    shift
    ;;
  -r | --repository)
    REPOSITORY="$2"
    shift
    ;;
  *)
    echo Invalid option \"$1\"
    exit 1
    ;;
  esac
  shift
done

DOCKERFILES=($(find . -maxdepth 1 -type f -iname "Dockerfile.*"))

for DOCKERFILE in "${DOCKERFILES[@]}" ; do
    NAME=$(grep -m 1 "ARG ARTIFACT_NAME" ${DOCKERFILE} | sed 's/.*\"\(.*\)\"/\1/g')
    TAG=$(grep -m 1 "ARG ARTIFACT_TAG" ${DOCKERFILE} | sed 's/.*\"\(.*\)\"/\1/g')
    buildImage ${DOCKERFILE} ${NAME} ${TAG}
done

exit
