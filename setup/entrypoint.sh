#!/bin/sh
# Creates the first Tindra administrator exactly once.
# Required variables: SETUP_ADMIN_EMAIL, SETUP_ADMIN_PASSWORD (min 12 chars).
# Optional variable: SETUP_ADMIN_NAME (defaults to the email address).
set -u

: "${SETUP_ADMIN_EMAIL:?SETUP_ADMIN_EMAIL is required}"
: "${SETUP_ADMIN_PASSWORD:?SETUP_ADMIN_PASSWORD is required}"
name="${SETUP_ADMIN_NAME:-$SETUP_ADMIN_EMAIL}"

out=$(/tindra users create --email "$SETUP_ADMIN_EMAIL" --name "$name" --password "$SETUP_ADMIN_PASSWORD" 2>&1)
code=$?
echo "$out"

if [ "$code" -eq 0 ]; then
  echo "First administrator created."
  exit 0
fi

case "$out" in
  *users_email_key*)
    echo "Administrator already exists; nothing to do."
    exit 0
    ;;
esac

# Any other failure (database not ready yet, bad credentials) exits non-zero
# so Railway's restart policy retries after the database becomes healthy.
exit "$code"
