#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

IMAGE_REFERENCE="${1:-final-devsecops-api:local}"

OUTPUT_DIRECTORY="${2:-$PROJECT_DIRECTORY/artifacts}"

OUTPUT_FILE="$OUTPUT_DIRECTORY/final-devsecops-api.tar.gz"

CHECKSUM_FILE="$OUTPUT_DIRECTORY/final-devsecops-api.tar.gz.sha256"

mkdir -p "$OUTPUT_DIRECTORY"

echo "Docker Image Export"
echo "==================="
echo ""
echo "Image:  $IMAGE_REFERENCE"
echo "Output: $OUTPUT_FILE"
echo ""

docker image inspect "$IMAGE_REFERENCE" \
  >/dev/null

echo "1. Saving compressed image"

docker save "$IMAGE_REFERENCE" |
  gzip > "$OUTPUT_FILE"

echo "2. Generating checksum"

(
  cd "$OUTPUT_DIRECTORY"

  sha256sum \
    "$(basename "$OUTPUT_FILE")" \
    > "$(basename "$CHECKSUM_FILE")"
)

echo ""
ls -lh \
  "$OUTPUT_FILE" \
  "$CHECKSUM_FILE"

echo ""
cat "$CHECKSUM_FILE"
