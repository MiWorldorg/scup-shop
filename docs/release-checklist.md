# Final Release Checklist

This checklist is intentionally not marked complete. It is the gate before creating a stable release/tag or making portfolio claims about tested behavior.

## 1. Source and repository

- [ ] Review and merge stacked phase PRs in order after human review.
- [ ] Verify the final branch is based on the intended release commit.
- [ ] Check all relative README/docs links.
- [ ] Review the full diff and open issues.
- [ ] Run a secret scan and dependency/security review.
- [ ] Confirm no .env, credentials, personal data, or generated build artifacts are committed.
- [ ] Confirm private visibility and no LICENSE file remain consistent with the owner's decision.

## 2. Automated quality

- [ ] Run the manual GitHub Actions CI workflow.
- [ ] Resolve Flutter format/analyzer/test failures.
- [ ] Resolve Laravel Pint/PHPUnit failures.
- [ ] Resolve Android, Web, Windows, and Linux build failures.
- [ ] Record the exact successful commit SHA and workflow run URL.
- [ ] Do not add a passing CI badge until a run for the final commit succeeds.

## 3. Database and backend

- [ ] Verify clean database setup and all migrations on MySQL.
- [ ] Validate data-transforming migrations against a disposable copy with representative legacy data.
- [ ] Verify backup and restore rehearsal.
- [ ] Verify API HTTPS, CORS, trusted proxy, and security-header behavior in a production-like environment.
- [ ] Verify Passport login, token persistence, expiry, revocation, and administrator authorization.
- [ ] Review query plans with representative data and confirm index usefulness.

## 4. Contact and integrations

- [ ] Configure a real CONTACT_TO_ADDRESS and SMTP provider.
- [ ] Submit a contact form and verify receipt in the intended inbox.
- [ ] Verify Reply-To, failure handling, rate limiting, and provider logs.
- [ ] Confirm no secrets appear in logs.

## 5. UI, accessibility, and performance

- [ ] Review representative mobile, tablet, desktop, and wide-desktop viewports.
- [ ] Verify keyboard-only navigation and focus order.
- [ ] Verify screen-reader labels and live announcements on Android and Web.
- [ ] Verify text scaling at 200%.
- [ ] Verify reduced-motion behavior.
- [ ] Profile startup, navigation, image loading, list rendering, and API latency before making performance claims.
- [ ] Review screenshots for contrast, clipping, overflow, and empty/error states.

## 6. Portfolio and release

- [ ] Capture genuine desktop and mobile screenshots from the verified build.
- [ ] Deploy a demo only after production configuration and security checks.
- [ ] Update README links and status to match the deployed release.
- [ ] Add a changelog entry with the final release version/date only when known.
- [ ] Create a stable tag only after all P1 checks pass.
- [ ] Publish a portfolio/LinkedIn post only with verified role, period, links, and capabilities.

## Current status

Implementation PRs are stacked and remain drafts. The manual CI workflow has not been executed. No stable release, live demo, screenshots, or verified build is claimed.
