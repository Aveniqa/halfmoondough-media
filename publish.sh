#!/bin/zsh
# Put a finished file on the public media repo and print its URL for Metricool's createScheduledPost "media".
# Usage: ./publish.sh <file> [name-in-repo]   (videos go under v/, images under i/)
set -e
HERE=${0:A:h}; SRC=$1; NAME=${2:-${SRC:t}}
case ${NAME:e:l} in mp4|mov) DIR=v;; *) DIR=i;; esac
mkdir -p $HERE/$DIR; cp "$SRC" "$HERE/$DIR/$NAME"
cd $HERE; git add "$DIR/$NAME"; git commit -q -m "Add $DIR/$NAME" -m "Co-Authored-By: Claude Opus 5.5 <noreply@anthropic.com>"; git push -q
URL="https://raw.githubusercontent.com/Aveniqa/halfmoondough-media/main/$DIR/$NAME"
for i in 1 2 3 4 5; do code=$(curl -s -o /dev/null -w "%{http_code}" -I "$URL"); [[ $code == 200 ]] && break; sleep 2; done
echo "$URL"
