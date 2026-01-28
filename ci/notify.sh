#!/usr/bin/env bash
set -e

STATUS="$1"
WEBHOOK_URL="$2"

if [[ -z "$STATUS" || -z "$WEBHOOK_URL" ]]; then
  echo "Usage: notify.sh <STATUS> <MAKE_WEBHOOK_URL>"
  exit 1
fi

echo "Sending notification to Make..."
echo "Status: $STATUS"

payload=$(cat <<EOF
{
  "job_name": "${JOB_NAME}",
  "build_number": "${BUILD_NUMBER}",
  "status": "${STATUS}",
  "branch": "${GIT_BRANCH}",
  "build_url": "${BUILD_URL}",
  "environment": "dev",
  "timestamp": "$(date -u +"%Y-%m-%dT%H:%M:%SZ")"
}
EOF
)

curl -s -X POST "$WEBHOOK_URL" \
  -H "Content-Type: application/json" \
  -d "$payload"

echo "Notification sent successfully"
