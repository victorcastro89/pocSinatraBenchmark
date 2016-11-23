#!/bin/bash

  bundle install --jobs=4

# Enable Puma's clustered mode with about one process per hardware thread,
# scaling up to a maximum of about 256 concurrent threads. NOTE: I was having
# trouble keeping two cores saturated with only two workers, thus the "fuzzy"
# math here.

WORKERS=$(( $(nproc || echo 7) + 1 ))
MAX_THREADS=$(( 256 / WORKERS + 1 )) ; export MAX_THREADS
MIN_THREADS=$(( MAX_THREADS / 4 + 1 ))


  bundle exec puma -w $WORKERS -t $MIN_THREADS:$MAX_THREADS -b tcp://0.0.0.0:8080 -e production &
