#!/bin/bash
set -euo pipefail

error_handler() {
  echo
  echo "Something went wrong."
  echo "Please check the permissions of the file and make sure to provide a valid Share URL from Google Drive."
  echo
  echo "Example:"
  echo "./gdwget.sh \"https://drive.google.com/file/d/1vW_EQUXFqdi4DUZZkS0_imgY52WRiHlh/view?usp=sharing\""
  exit 1
}

trap error_handler ERR


URL="${1:-}"
HTML="/tmp/gdrive_probe_$$.html"
COOKIE="/tmp/gdrive_cookie_$$.txt"

trap 'rm -f "$HTML" "$COOKIE"' EXIT

if [[ -z "$URL" ]]; then
  echo "Usage: $0 <google_drive_url>"
  exit 1
fi

if [[ "$URL" != *google* || ( "$URL" != *drive* && "$URL" != *docs* ) ]]; then
  echo "This is not a Google Drive URL"
  exit 1
fi

echo "Your Origin URL: $URL"

ID=$(echo "$URL" | awk -F'/' '{print $6}')

echo "File's ID: $ID"

DOWNLOAD="https://drive.usercontent.google.com/download?id=${ID}&export=download"

wget -qO "$HTML" --save-cookies "$COOKIE" --keep-session-cookies "$DOWNLOAD"

if file -b --mime-type "$HTML" | grep -qE 'text/|application/xhtml\+xml'; then
  CONFIRM="$(sed -n 's/.*name="confirm" value="\([^"]*\)".*/\1/p' "$HTML" | head -n1)"
else
  CONFIRM=""
fi

if [[ -n "$CONFIRM" ]]; then
  echo "Downloading with Confirmation Token"
  wget -q --show-progress --content-disposition --load-cookies "$COOKIE" "https://drive.usercontent.google.com/download?id=${ID}&confirm=${CONFIRM}&export=download"
else
  echo "Downloading without Confirmation Token"
  wget -q --show-progress --content-disposition --load-cookies "$COOKIE" "https://drive.usercontent.google.com/download?id=${ID}&export=download"
fi
