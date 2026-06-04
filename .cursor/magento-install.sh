#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
cd "${ROOT_DIR}"

if [[ -f app/etc/env.php ]]; then
    echo "Magento is already installed (app/etc/env.php exists)."
    exit 0
fi

bash "${ROOT_DIR}/.cursor/start-services.sh"
bash "${ROOT_DIR}/.cursor/setup-sample-data.sh"

php bin/magento setup:install \
    --base-url="${MAGENTO_BASE_URL:-http://127.0.0.1:8082/}" \
    --db-host="${MAGENTO_DB_HOST:-127.0.0.1}" \
    --db-name="${MAGENTO_DB_NAME:-magento}" \
    --db-user="${MAGENTO_DB_USER:-magento}" \
    --db-password="${MAGENTO_DB_PASSWORD:-magento}" \
    --admin-firstname="${MAGENTO_ADMIN_FIRSTNAME:-Admin}" \
    --admin-lastname="${MAGENTO_ADMIN_LASTNAME:-User}" \
    --admin-email="${MAGENTO_ADMIN_EMAIL:-admin@example.com}" \
    --admin-user="${MAGENTO_ADMIN_USER:-admin}" \
    --admin-password="${MAGENTO_ADMIN_PASSWORD:-Admin123!}" \
    --language=en_US \
    --currency=USD \
    --timezone=America/Los_Angeles \
    --use-rewrites=1 \
    --backend-frontname=admin \
    --search-engine=opensearch \
    --opensearch-host="${MAGENTO_OPENSEARCH_HOST:-127.0.0.1}" \
    --opensearch-port="${MAGENTO_OPENSEARCH_PORT:-9200}" \
    --use-sample-data \
    --magento-init-params="MAGE_MODE=developer"

echo ""
echo "Magento installed."
echo "Storefront: ${MAGENTO_BASE_URL:-http://127.0.0.1:8082/}"
echo "Admin:      ${MAGENTO_BASE_URL:-http://127.0.0.1:8082/}admin"
echo "User:       ${MAGENTO_ADMIN_USER:-admin} / ${MAGENTO_ADMIN_PASSWORD:-Admin123!}"
