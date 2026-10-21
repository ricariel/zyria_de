#!/bin/sh
# Snapshot the Home Assistant configuration into its Git repository.
#
# Runs as a sidecar next to Home Assistant and shares the /config volume. The
# running instance is the source of truth: every run puts the working tree on
# top of the remote branch without merging, commits whatever differs and
# pushes. Nothing is ever checked out into /config.
set -u

: "${BACKUP_REMOTE:?BACKUP_REMOTE must be set}"
: "${BACKUP_DIR:=/config}"
: "${BACKUP_BRANCH:=main}"
: "${BACKUP_INTERVAL:=3600}"
: "${BACKUP_KEY:=/backup-key/ssh-privatekey}"
: "${BACKUP_KNOWN_HOSTS:=/backup/known_hosts}"

export GIT_SSH_COMMAND="ssh -i ${BACKUP_KEY} -o IdentitiesOnly=yes -o StrictHostKeyChecking=yes -o UserKnownHostsFile=${BACKUP_KNOWN_HOSTS}"
export GIT_AUTHOR_NAME="Home Assistant config backup"
export GIT_AUTHOR_EMAIL="noreply@zyria.de"
export GIT_COMMITTER_NAME="${GIT_AUTHOR_NAME}"
export GIT_COMMITTER_EMAIL="${GIT_AUTHOR_EMAIL}"

log() {
  printf '%s level=%s msg="%s"\n' "$(date -u +%Y-%m-%dT%H:%M:%SZ)" "$1" "$2"
}

snapshot() {
  cd "${BACKUP_DIR}" || return 1
  git remote set-url origin "${BACKUP_REMOTE}" || return 1
  git fetch --quiet origin "${BACKUP_BRANCH}" || return 1
  git reset --quiet --soft "origin/${BACKUP_BRANCH}" || return 1

  # Drop files from the index that .gitignore excludes by now.
  git ls-files -z --cached --ignored --exclude-standard \
    | xargs -0 -r git rm --cached --quiet -- || return 1
  git add --all || return 1

  if git diff --cached --quiet; then
    log info "no changes"
    return 0
  fi

  count=$(git diff --cached --name-only | wc -l | tr -d ' ')
  files=$(git diff --cached --no-renames --name-status | head -n 8 \
    | awk '{ s = ($1 == "A") ? "added" : ($1 == "D") ? "deleted" : "modified"; printf "- %s: %s\n", $2, s }')
  more=""
  if [ "${count}" -gt 8 ]; then
    more="
and $((count - 8)) more"
  fi

  git commit --quiet --no-verify -F - <<EOF || return 1
chore(config): snapshot running configuration

Automatic snapshot of ${BACKUP_DIR}, ${count} file(s) changed.

${files}${more}
EOF
  git push --quiet origin "HEAD:${BACKUP_BRANCH}" || return 1
  log info "pushed ${count} changed file(s)"
}

git config --global --add safe.directory "${BACKUP_DIR}"

while true; do
  if ! snapshot; then
    log error "snapshot failed, retrying in ${BACKUP_INTERVAL}s"
  fi
  sleep "${BACKUP_INTERVAL}"
done
