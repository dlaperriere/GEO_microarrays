#!/usr/bin/env bash

source env.sh

DOCKER_RUN_OPTIONS="-i "

# Only allocate tty if we detect one   (ex. terminal vs jenkins job)
if [ -t 0 ] && [ -t 1 ]; then
    DOCKER_RUN_OPTIONS="$DOCKER_RUN_OPTIONS -t"
fi

echo "Starting $img_name:$img_version"
docker_cmd="docker run $DOCKER_RUN_OPTIONS -v $src_dir:/src  $img_name:$img_version $1"
echo $docker_cmd
$docker_cmd

