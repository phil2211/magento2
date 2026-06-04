#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

echo "Installing Composer dependencies..."
composer install --no-interaction --prefer-dist

echo "Linking sample data..."
bash "${ROOT_DIR}/.cursor/setup-sample-data.sh"

echo "Install complete."
