#!/usr/bin/env bash

set -euo pipefail

PROJECT_DIRECTORY="$(
  cd "$(dirname "${BASH_SOURCE[0]}")/.." &&
  pwd
)"

cd "$PROJECT_DIRECTORY"

IMAGE_REFERENCE="${1:-devops-ci-api:local}"
OUTPUT_DIRECTORY="${2:-artifacts}"
OUTPUT_FILE="$OUTPUT_DIRECTORY/devops-ci-api.tar.gz"
CHECKSUM_FILE="$OUTPUT_DIRECTORY/devops-ci-api.tar.gz.sha256"

mkdir -p "$OUTPUT_DIRECTORY"

echo "Docker Image Export"
echo "==================="
echo ""
echo "Image:  $IMAGE_REFERENCE"
echo "Output: $OUTPUT_FILE"
echo ""

echo "1. Confirming image exists"

docker image inspect "$IMAGE_REFERENCE" \
  >/dev/null

echo "2. Saving compressed image"

docker save "$IMAGE_REFERENCE" |
  gzip > "$OUTPUT_FILE"

echo "3. Generating SHA-256 checksum"

(
  cd "$OUTPUT_DIRECTORY"

  sha256sum \
    "$(basename "$OUTPUT_FILE")" \
    > "$(basename "$CHECKSUM_FILE")"
)

echo ""
echo "Generated files:"

ls -lh \
  "$OUTPUT_FILE" \
  "$CHECKSUM_FILE"

echo ""
echo "Checksum:"

cat "$CHECKSUM_FILE"