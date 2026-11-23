# Testing and Quality Plan

## Execution policy

The project owner requested that tests, formatters, analyzers, and builds be deferred until implementation phases are complete. Test cases and a manual CI workflow are being prepared now, but no suite or build is to be run before the final QA phase.

The workflow at .github/workflows/ci.yml is intentionally triggered only through workflow_dispatch. It does not run automatically on pushes or pull requests while implementation is in progress.

## Current automated coverage in source

### Flutter

| Area | Current test coverage |
| --- | --- |
| API response parsing | Pagination metadata, default pagination, malformed envelopes, validation error mapping |
| Accessibility states | Async loading, empty, and error messages are exposed through semantic live regions |
| Product DTO | Product/category/inventory parsing, missing and malformed values |
| Post management DTO | Draft/published state and nullable image handling |
| Price formatter | Grouping, zero/small values, negative values |
| Shop controller | Stale-response protection, search pagination reset, category filter state |
| App smoke test | Landing route with fake repositories to avoid network dependency |

### Laravel

| Area | Current test coverage |
| --- | --- |
| Authentication | Generic invalid-credential response, login throttling, password policy, production HTTPS |
| Authorization | Missing/invalid/non-admin token, safe profile fields, role-change safeguards |
| Product and inventory | Inventory ownership, zero stock, product deletion constraints, dedicated inventory creation |
| Editorial | Draft visibility, admin CRUD, author identity, validation, missing records |
| Contact | Valid submission, validation/honeypot, missing mail destination, mail failure, rate limiting |
| Catalog query | Public search by name/SKU/description, category filtering, public categories, admin product/post search |

The current test files live in frontend/test/ and backend/tests/.

## Final local verification commands

### Flutter

    cd frontend
    flutter pub get
    dart format --output=none --set-exit-if-changed .
    flutter analyze
    flutter test

### Laravel

    cd backend
    composer install
    php artisan test
    vendor/bin/pint --test

Backend tests use an in-memory SQLite database. Ensure the PHP pdo_sqlite extension is available.

## Manual CI workflow

After the owner authorizes final QA, open the repository Actions tab, select the CI workflow, and run workflow_dispatch. It runs:

- Laravel dependency installation, Pint formatting check, and PHPUnit feature/unit suites.
- Flutter dependency installation, formatting check, analyzer, and widget/unit tests.
- Flutter builds for Web, Android APK, Windows, and Linux.

The workflow has not been executed. No green CI status is claimed.

## Manual integration and release checks

- Configure a real SMTP provider and verify a contact message reaches the intended inbox; a 202 API response alone is not proof of inbox delivery.
- Verify Passport setup and administrator login on a clean local database.
- Verify catalog filtering, product CRUD, post publishing, and role-management flows against a disposable database.
- Review data migrations against a backup/disposable copy before applying them to retained data.
- Verify responsive layouts and keyboard/screen-reader behavior at representative mobile, tablet, desktop, and wide-desktop sizes.
- Confirm the API URL is reachable from Android emulator, Web, Windows, and Linux targets.
- Review secrets, dependencies, docs, and final screenshots before marking the release complete.
