#! /usr/bin/env bash

set -e

# Remove a potentially pre-existing server.pid for Rails.
if [ -f /app/tmp/pids/server.pid ]; then
  rm -f /app/tmp/pids/server.pid
fi

bin/rails db:migrate db:migrate:with_data

exec "$@"
