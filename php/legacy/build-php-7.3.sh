#!/bin/bash

# shellcheck disable=SC2086
set -eux;

cd "$(dirname $0)";

### PHP 7.3
if [ "${NO_PULL:-0}" -ne "1" ]; then
    docker pull php:7.3-apache
    docker run --rm php:7.3-apache php --version
fi

if [ "${NO_BUILD:-0}" -ne "1" ]; then
    docker build --progress plain -f ./Dockerfile-7.3 -t jakubboucek/lamp-devstack-php:7.3-legacy ../
    docker build --progress plain -f ./Dockerfile-7.3-debug -t jakubboucek/lamp-devstack-php:7.3-legacy-debug ../
fi

if [ "${NO_TEST:-0}" -ne "1" ]; then
    docker run --rm jakubboucek/lamp-devstack-php:7.3-legacy php --version
    docker run --rm jakubboucek/lamp-devstack-php:7.3-legacy-debug php --version
    docker run --rm jakubboucek/lamp-devstack-php:7.3-legacy php -r "echo implode(', ', get_loaded_extensions()) . PHP_EOL;"
    docker run --rm jakubboucek/lamp-devstack-php:7.3-legacy-debug php -r "echo implode(', ', get_loaded_extensions()) . PHP_EOL;"
    docker run --rm jakubboucek/lamp-devstack-php:7.3-legacy php -r "var_export(gd_info()) . PHP_EOL;"
fi

if [ "${NO_PUSH:-0}" -ne "1" ]; then
    docker push jakubboucek/lamp-devstack-php:7.3-legacy-debug
    docker push jakubboucek/lamp-devstack-php:7.3-legacy
fi
