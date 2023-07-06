#!/usr/bin/env sh

set -e

eval $(ssh-agent -s)

if [ ! -z "${SSH_KEY}" ]; then
  ssh-add "${SSH_KEY}"
fi

if [ -f ~/my_blog/tmp/pids/server.pid ]; then
  rm ~/my_blog/tmp/pids/server.pid
fi

bundle check || bundle install \
  --jobs $(($(grep -c "cpu cores" /proc/cpuinfo) - 1)) \
  --retry 3

yarn check --check-files || yarn install

exec "$@"
