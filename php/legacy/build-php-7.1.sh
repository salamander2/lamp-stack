#!/bin/bash

# shellcheck disable=SC2086
set -eux;

cd "$(dirname $0)";

### PHP 7.1
docker pull php:7.1-apache
docker run --rm php:7.1-apache php --version
docker build --progress plain -f ./Dockerfile-7.1 -t jakubboucek/lamp-devstack-php:7.1-legacy ../
docker build --progress plain -f ./Dockerfile-7.1-debug -t jakubboucek/lamp-devstack-php:7.1-legacy-debug ../
docker run --rm jakubboucek/lamp-devstack-php:7.1-legacy php --version
docker run --rm jakubboucek/lamp-devstack-php:7.1-legacy-debug php --version
docker run --rm jakubboucek/lamp-devstack-php:7.1-legacy php -r "echo implode(', ', get_loaded_extensions()) . PHP_EOL;"
docker run --rm jakubboucek/lamp-devstack-php:7.1-legacy php -r "var_export(gd_info()) . PHP_EOL;"
docker push jakubboucek/lamp-devstack-php:7.1-legacy-debug
docker push jakubboucek/lamp-devstack-php:7.1-legacy
