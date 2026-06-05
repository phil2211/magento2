# Agent instructions — Magento 2

Instructions for AI agents working in this repository. Cloud Agents read this file automatically when they start a session in the Cursor cloud VM.

## Cursor Cloud — Magento 2 Admin

### Environment overview

| Item | Value |
|------|-------|
| Base URL | `http://127.0.0.1:8082` (override with `MAGENTO_BASE_URL`) |
| Admin login | `http://127.0.0.1:8082/admin` |
| Backend frontname | `admin` |
| Web server | PHP built-in server via `phpserver/router.php` |
| Database | MySQL/MariaDB on `127.0.0.1:3306` (Docker) |
| Search | OpenSearch on `127.0.0.1:9200` (Docker) |
| Mode | `developer` (set at install) |

Configuration lives in `.cursor/environment.json`. Cloud-specific scripts are in `.cursor/`.

### Required secrets (Cursor Dashboard → Cloud Agents)

Set these in the Cloud Agents secrets tab — do not commit credentials:

| Secret | Default (local/cloud install script) |
|--------|--------------------------------------|
| `MAGENTO_BASE_URL` | `http://127.0.0.1:8082` |
| `MAGENTO_DB_HOST` | `127.0.0.1` |
| `MAGENTO_DB_NAME` | `magento` |
| `MAGENTO_DB_USER` | `magento` |
| `MAGENTO_DB_PASSWORD` | `magento` |
| `MAGENTO_OPENSEARCH_HOST` | `127.0.0.1` |
| `MAGENTO_OPENSEARCH_PORT` | `9200` |
| `MAGENTO_ADMIN_USER` | `admin` |
| `MAGENTO_ADMIN_PASSWORD` | `Admin123!` |

### Bootstrap (run from repo root)

```bash
# 1. Start MySQL + OpenSearch (requires Docker)
bash .cursor/start-services.sh

# 2. Composer deps + sample data link
bash .cursor/install.sh

# 3. First-time Magento install only (skip if app/etc/env.php exists)
bash .cursor/magento-install.sh

# 4. Web server (also started via environment.json terminals)
php -S 127.0.0.1:8082 -t pub/ phpserver/router.php
```

If Magento is already installed:

```bash
php bin/magento setup:upgrade --keep-generated
php bin/magento cache:flush
```

### Admin login (browser automation)

| Field | Selector |
|-------|----------|
| Username | `#username` |
| Password | `#login` |
| Sign in | `.actions .action-primary` |

After login, dismiss admin notification modals if they block the UI. Confirm the dashboard loads at `/admin/dashboard/`.

### After Admin UI changes

```bash
php bin/magento cache:flush
```

Also run when applicable:

```bash
php bin/magento setup:upgrade          # schema/data patches
php bin/magento setup:di:compile       # only if needed for the change type
```

### Admin demo and PR artifacts

For UI work, Cloud Agents must:

1. Verify the feature in a real browser in the cloud VM.
2. Record a short demo video (30–90 seconds) of the Admin workflow.
3. Open or update the PR through Cursor git/PR tools (not `gh pr edit`).
4. Embed the video and screenshots in the **PR description** (requires “Allow posting artifacts to GitHub” in Cloud Agents dashboard settings).

Full automation prompt template: `.cursor/cloud-agent-admin-prompt.md`

### Common Admin pitfalls

- **Cache** — flush after layout, block, or template changes.
- **ACL** — new menus/actions need `acl.xml` and role assignment; “Access denied” usually means missing ACL.
- **Grids** — use a fresh entity or reset grid state if new columns/filters do not appear.
- **Notifications** — close the post-login notification popup before clicking through the UI.
- **Sample data** — install uses `--use-sample-data`; prefer existing catalog entities for demos.

### Scope defaults

- Prefer changes under `app/code/Magento/` following existing module patterns.
- Admin UI scope unless the task explicitly requires storefront changes.
- Minimal diffs; no unrelated refactors.

### Useful commands

| Action | Command |
|--------|---------|
| Install services | `bash .cursor/start-services.sh` |
| Install deps | `bash .cursor/install.sh` |
| Install Magento | `bash .cursor/magento-install.sh` |
| Flush cache | `php bin/magento cache:flush` |
| Module status | `php bin/magento module:status` |
| Run unit tests (module) | `vendor/bin/phpunit -c dev/tests/unit/phpunit.xml.dist` |
