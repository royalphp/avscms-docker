#!/bin/sh
set -e

server-entrypoint

exec docker-php-entrypoint "$@"
