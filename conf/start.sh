#!/usr/bin/env bash

set -e

PRE_START_PATH=/app/prestart.sh
echo "Checking for script $PRE_START_PATH"
if [ -f $PRE_START_PATH ] ; then
    echo "Running script $PRE_START_PATH"
    source $PRE_START_PATH
else
    echo "There is no script $PRE_START_PATH"
fi

echo "py-debian-conda-flask-$APP_ENV: Starting supervisord"

exec /usr/bin/supervisord