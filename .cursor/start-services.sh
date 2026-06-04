#!/usr/bin/env bash
set -euo pipefail

ROOT_DIR="$(cd "$(dirname "${BASH_SOURCE[0]}")/.." && pwd)"
COMPOSE_FILE="${ROOT_DIR}/.cursor/docker-compose.services.yml"

if command -v sudo >/dev/null 2>&1; then
    sudo service docker start >/dev/null 2>&1 || sudo docker info >/dev/null 2>&1 || true
fi

if ! docker info >/dev/null 2>&1; then
    echo "Docker is not running. Start Docker before using MySQL/OpenSearch services." >&2
    exit 1
fi

docker compose -f "${COMPOSE_FILE}" up -d
bash "${ROOT_DIR}/.cursor/wait-for-services.sh"
