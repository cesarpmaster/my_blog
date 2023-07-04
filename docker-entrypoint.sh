#!/usr/bin/env sh

set -e

if [ -f ~/my_blog/tmp/pids/server.pid ]; then
  rm ~/my_blog/tmp/pids/server.pid
fi

bundle check || bundle install \
  --jobs $(($(grep -c "cpu cores" /proc/cpuinfo) - 1)) \
  --retry 3

yarn check --check-files || yarn install

exec "$@"
