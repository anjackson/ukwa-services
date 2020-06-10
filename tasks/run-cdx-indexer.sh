#!/bin/bash

# Fail on errors:
set -e

# Common vars:
export DIR=$(dirname "$0")
source ${DIR}/task.env.sh

# Specific vars:
export STREAM="frequent"
export YEAR="2020"

# Ensure we only run one copy of this script at a time:
LOCKFILE="/var/tmp/`basename $0`.lock"
touch $LOCKFILE
unset lockfd
(
    # Check lock and exit if locked:
    flock -n $lockfd || { echo `basename $0` "is already running!"; exit 1; }

    echo "CDX indexing WARCs from $TRACKDB_URL for ${STREAM} ${YEAR} and using ${TASK_IMG}..."
    docker run -i $TASK_IMG windex cdx-index \
        --trackdb-url $TRACKDB_URL \
        --stream $STREAM \
        --year $YEAR \
        --cdx-collection data-heritrix \
        --cdx-service "http://cdx.api.wa.bl.uk" \
        --batch-size 1000

) {lockfd}< $LOCKFILE

