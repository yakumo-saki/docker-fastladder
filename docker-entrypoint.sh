#!/bin/bash
set -e

# jemalloc を LD_PRELOAD に設定
JEMALLOC_PATH="$(ldconfig -p | awk '/libjemalloc.so.2/ { print $NF; exit }')"

if [ -n "$JEMALLOC_PATH" ]; then
  export LD_PRELOAD="$JEMALLOC_PATH${LD_PRELOAD:+:$LD_PRELOAD}"
fi

# DB prepare が必要なら実行
if [ "$RAILS_ENV" = "production" ]; then
  ./bin/rails db:prepare
fi

exec "$@"
