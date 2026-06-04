#!/usr/bin/env bash
set -euo pipefail

MAX_ATTEMPTS="${WAIT_FOR_SERVICES_ATTEMPTS:-60}"
SLEEP_SECONDS="${WAIT_FOR_SERVICES_SLEEP:-2}"

wait_for_port() {
    local host="$1"
    local port="$2"
    local label="$3"
    local attempt=1

    while (( attempt <= MAX_ATTEMPTS )); do
        if (echo > "/dev/tcp/${host}/${port}") >/dev/null 2>&1; then
            echo "${label} is ready on ${host}:${port}."
            return 0
        fi
        echo "Waiting for ${label} (${attempt}/${MAX_ATTEMPTS})..."
        sleep "${SLEEP_SECONDS}"
        (( attempt++ ))
    done

    echo "Timed out waiting for ${label} on ${host}:${port}." >&2
    return 1
}

wait_for_port "127.0.0.1" "3306" "MySQL"
wait_for_port "127.0.0.1" "9200" "OpenSearch"
