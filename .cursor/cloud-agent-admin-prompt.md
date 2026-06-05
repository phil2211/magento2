# Cloud Agent prompt — Magento 2 Admin UI

Use this as the **Instructions** body for a Cursor Automation that runs a Cloud Agent with the **Open or update PRs** (`gitPr`) tool enabled.

Replace `{{TASK_DESCRIPTION}}` and optionally `{{BRANCH_NAME}}` when configuring the automation. See `AGENTS.md` for environment bootstrap and required secrets.

---

## Task

{{TASK_DESCRIPTION}}

Branch name: `{{BRANCH_NAME}}` (if empty, choose a short descriptive name such as `feature/admin-<summary>`).

Scope: **Magento 2 Admin UI only** unless the task explicitly requires storefront changes.

---

## Runtime

You are a **Cursor Cloud Agent** with **computer use**. Run in the cloud VM, verify Admin behavior in a browser, record a demo video, and open a PR with embedded artifacts.

Do **not** mark this task complete without a browser-verified Admin demo and a PR description that includes the video for reviewers.

Read `AGENTS.md` and `.cursor/environment.json` before starting.

---

## Bootstrap sequence

Run from the repository root, in order:

1. `bash .cursor/start-services.sh` — Docker MySQL + OpenSearch
2. `bash .cursor/install.sh` — Composer + sample data
3. If `app/etc/env.php` does **not** exist: `bash .cursor/magento-install.sh`
4. If already installed: `php bin/magento setup:upgrade --keep-generated && php bin/magento cache:flush`
5. Ensure the web server is running on port 8082 (see `environment.json` terminals):
   `php -S 127.0.0.1:8082 -t pub/ phpserver/router.php`
6. Confirm Admin is reachable at `$MAGENTO_BASE_URL/admin` (default `http://127.0.0.1:8082/admin`)

Fix bootstrap failures before implementing the feature.

---

## Admin credentials

Use Cloud Agent secrets — never commit credentials:

- **URL:** `$MAGENTO_BASE_URL/admin`
- **Username:** `$MAGENTO_ADMIN_USER` (default `admin`)
- **Password:** `$MAGENTO_ADMIN_PASSWORD` (default `Admin123!`)

Login selectors: `#username`, `#login`, `.actions .action-primary`

---

## Implementation rules

1. **Minimal scope** — only what the task requires; match patterns in `app/code/Magento/`.
2. **Admin UI** — UI components, layout XML, blocks, controllers, ACL, `system.xml` as needed.
3. **Developer mode** — flush cache after view/layout changes; run `setup:upgrade` for schema/data patches.
4. **ACL** — grant admin role access to new resources; document in PR if manual assignment is needed.
5. **No secrets in git.**

---

## Admin UI verification (mandatory)

Record a **30–90 second** browser demo:

1. Open `$MAGENTO_BASE_URL/admin` and log in
2. Navigate to the affected Admin area
3. Show baseline state (before or without the change) if meaningful
4. Perform the merchant workflow (create/edit/save, grids, modals, mass actions)
5. Show the result — persistence after reload if applicable
6. Brief edge case (validation, empty state) if relevant and quick

Screenshots to capture:

- Dashboard after login
- Key screen before change (if meaningful)
- Key screen after change showing new behavior

If the UI does not reflect changes, run `php bin/magento cache:flush` and re-test.

---

## PR delivery (mandatory)

1. Commit on the feature branch with a clear message focused on **why**.
2. **Create the PR using Cursor git/PR tools** — not `gh pr create` or `gh pr edit` for the final description.
3. PR description sections:

   ### Summary
   - 3–5 bullets: what changed in Admin and why

   ### Demo
   - Embedded **video** of the Admin walkthrough (required)
   - 2–3 **screenshots** at key steps

   ### How to verify manually
   - Exact Admin navigation path
   - URLs and bootstrap commands from `AGENTS.md`
   - Credentials via Cloud Agent secrets

   ### Technical notes
   - Modules/files touched
   - ACL resources added (if any)
   - DB schema / config changes (if any)

4. **Completion gate** — do not finish until:
   - Demo video exists in agent artifacts and plays in the Cursor session UI
   - PR description was updated through Cursor PR tools with embedded demo
   - You watched the video and confirmed it shows the Admin feature working

5. If artifact embedding fails, fix via Cursor PR tools. Do not use raw file paths or custom XML tags in GitHub comments as a substitute.

---

## Out of scope unless requested

- Storefront / theme / Luma changes
- Production deployment
- Unrelated refactors
- Full MFTF suite runs

---

## Success criteria

- [ ] Cloud environment bootstrapped (Docker, Magento, web server on 8082)
- [ ] Feature implemented with minimal diff
- [ ] Admin browser demo recorded (video + screenshots)
- [ ] PR opened by Cloud Agent with embedded demo in **PR description**
- [ ] Reviewer can understand the Admin change without checking out the branch
