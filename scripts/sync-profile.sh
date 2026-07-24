#!/bin/sh

# Syncs a user's full home directory from a remote server onto this machine.
#
# Usage: sync-profile.sh --source-user USER --source-server HOST [--dest-user USER]

set -e

DEST_USER=$(whoami)
SOURCE_USER=""
SOURCE_SERVER=""

usage() {
    echo "Usage: $0 --source-user USER --source-server HOST [--dest-user USER]" >&2
    exit 1
}

while [ $# -gt 0 ]; do
    [ $# -lt 2 ] && usage
    case "$1" in
        --source-user)
            SOURCE_USER="$2"
            shift 2
            ;;
        --source-server)
            SOURCE_SERVER="$2"
            shift 2
            ;;
        --dest-user)
            DEST_USER="$2"
            shift 2
            ;;
        *)
            usage
            ;;
    esac
done

[ -z "$SOURCE_USER" ] && usage
[ -z "$SOURCE_SERVER" ] && usage

DEST_HOME=$(getent passwd "$DEST_USER" | cut -d: -f6)
if [ -z "$DEST_HOME" ]; then
    echo "No local user '$DEST_USER' found." >&2
    exit 1
fi

echo "Syncing ${SOURCE_USER}@${SOURCE_SERVER}:~ -> ${DEST_HOME} (as ${DEST_USER})"

sudo rsync -a --info=progress2 \
    -e ssh \
    "${SOURCE_USER}@${SOURCE_SERVER}:/home/${SOURCE_USER}/" \
    "${DEST_HOME}/"

# rsync preserves permission bits via -a; ownership is fixed up here since
# the source account's uid/gid rarely matches the destination account's.
sudo chown -R "${DEST_USER}:${DEST_USER}" "${DEST_HOME}"
