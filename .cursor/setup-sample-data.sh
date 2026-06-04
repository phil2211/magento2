#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
SAMPLE_DATA_BRANCH="${MAGENTO_SAMPLE_DATA_BRANCH:-2.4-develop}"
SAMPLE_DATA_REPO="${MAGENTO_SAMPLE_DATA_REPO:-https://github.com/magento/magento2-sample-data.git}"
SAMPLE_DATA_DIR="${MAGENTO_SAMPLE_DATA_DIR:-/tmp/magento2-sample-data}"
MARKER_FILE="${ROOT_DIR}/.cursor/.sample-data-linked"

cd "${ROOT_DIR}"

if [[ -f "${MARKER_FILE}" ]]; then
    echo "Sample data already linked (${MARKER_FILE} exists)."
    exit 0
fi

if compgen -G "${ROOT_DIR}/app/code/Magento/*SampleData" > /dev/null; then
    echo "Sample data modules already present in app/code/Magento."
    mkdir -p "${ROOT_DIR}/.cursor"
    touch "${MARKER_FILE}"
    exit 0
fi

echo "Cloning sample data (${SAMPLE_DATA_BRANCH})..."
rm -rf "${SAMPLE_DATA_DIR}"
git clone --depth 1 --branch "${SAMPLE_DATA_BRANCH}" "${SAMPLE_DATA_REPO}" "${SAMPLE_DATA_DIR}"

echo "Linking sample data into Magento..."
php -f "${SAMPLE_DATA_DIR}/dev/tools/build-sample-data.php" -- --ce-source="${ROOT_DIR}"

mkdir -p "${ROOT_DIR}/.cursor"
touch "${MARKER_FILE}"
echo "Sample data linked successfully."
