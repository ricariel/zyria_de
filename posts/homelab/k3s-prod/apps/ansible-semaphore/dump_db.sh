#!/bin/bash
# Logical dump of the Semaphore database into the backup volume.
# Longhorn picks the volume up with its nightly "default" group job, so the
# dump reaches the NFS target without any extra plumbing.
set -euo pipefail

: "${APP:?APP is required}"
: "${DB_HOST:?DB_HOST is required}"
: "${DB_NAME:?DB_NAME is required}"
: "${MARIADB_ROOT_PASSWORD:?MARIADB_ROOT_PASSWORD is required}"
KEEP="${KEEP:-7}"

target="/backup/${APP}-$(date +%Y-%m-%dT%H%M).sql.gz"

# --single-transaction keeps Semaphore online: InnoDB serves the dump from a
# consistent snapshot instead of locking the tables. Running Ansible jobs
# write to the task log while the dump runs, which is exactly what the
# snapshot shields it from.
# --databases adds CREATE DATABASE, so a restore does not depend on the
# target database already existing.
#
# Deliberately without --routines and --events. The Bitnami instance reports
# "already upgraded" on every start, yet mysql.proc still carries the column
# layout of MariaDB 11.4.3 while the server runs 12.3.2. Reading routines
# therefore fails with error 1558 and mariadb-dump exits 2, which would take
# the whole job down. Nothing is lost: mysql.proc holds no routine and
# mysql.event no event for this database, only the 53 shipped sys routines.
# Revisit once the cutover is done.
mariadb-dump \
  --host="${DB_HOST}" \
  --user=root \
  --password="${MARIADB_ROOT_PASSWORD}" \
  --single-transaction \
  --quick \
  --triggers \
  --default-character-set=utf8mb4 \
  --databases "${DB_NAME}" \
  | gzip -c > "${target}.part"

# Rename only after a clean run, so a half-written file is never mistaken for
# a usable dump.
mv "${target}.part" "${target}"
echo "wrote ${target} ($(stat -c %s "${target}") bytes)"

# Drop leftovers from aborted runs, then trim to KEEP generations.
find /backup -maxdepth 1 -name "${APP}-*.sql.gz.part" -mmin +360 -delete
ls -1t /backup/"${APP}"-*.sql.gz | tail -n "+$((KEEP + 1))" | xargs -r rm -f
echo "kept $(ls -1 /backup/"${APP}"-*.sql.gz | wc -l) dumps"
