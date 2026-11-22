# Sculpture Shop Audit

**Audit date:** November 13, 2026  
**Process:** Part C1, step 1 only. No application code or configuration was changed.  
**Project details supplied:** Flutter app and backend for a university ecommerce project; period 2025; status archived; role is unresolved (`[solo / team]`).

## Summary

This repository contains a Flutter storefront and admin panel, a Laravel JSON API using Passport, and MySQL migrations. It has a repeatable product seeder with five sample products and two categories. The current implementation supports product browsing and product administration, user role administration, authentication, and public blog listing.

The repository does not currently implement a complete purchase flow: cart, order, and payment tables exist in the database schema, but no corresponding checkout or order-management API and Flutter flow were found. The admin posts area is also incomplete. The available documentation should describe these limits accurately.

## What exists

- Root `README.md`, `docs/architecture.md`, and `docs/database.md`; additional READMEs exist for the Flutter client and Laravel API.
- Flutter source under `frontend/lib/`, organized into core, public, authentication, and admin-panel areas. GetX is used for state management and routing. Theme colors and typography are centralized, assets are declared in `pubspec.yaml`, and `pubspec.lock` is present.
- Laravel source under `backend/app/`, API and web routes, migrations for catalog, users, orders, payments, and Passport, and `composer.lock`.
- `ProductSeeder` creates two product categories and five sample products using image paths that match bundled Flutter assets. `DatabaseSeeder` invokes it.
- `backend/.env.example` contains configuration placeholders. `backend/.env` also exists locally; its contents were not opened.
- Flutter, Laravel, and platform-specific test directories exist, but the tests are mostly framework starter examples.
- Local generated output and dependency caches are present under `frontend/build/`, `frontend/.dart_tool/`, and `backend/vendor/`. Ignore rules cover these paths, but tracking cannot be checked in the current checkout.

## Findings against the standard

### Repository and safety

- **Git history is unavailable.** The root `.git` directory exists but is empty/unusable; `git status` and `git rev-parse` report that this is not a Git repository. It is therefore not possible to determine which files are tracked, inspect commit history, run a history-based secrets scan, or create the backup tag required before deleting original code under C2. This blocks safe cleanup of possibly committed artifacts until repository metadata or an approved backup method is available.
- **Local environment file needs verification.** `backend/.env` is ignored by the root and backend ignore rules. Its values were not inspected, and its tracking/history status cannot be established. No claim is made that it is secret-free.
- **Fixed demo credentials are present in source and documentation.** The local seed setup uses fixed passwords, and the demo administrator credential is documented in the root and backend READMEs. The credential values are intentionally omitted here. This violates A2/B6; treat the exposed demo password as compromised and replace or remove it before any non-local use.
- Build output and dependency caches exist locally. Whether any generated artifacts were committed cannot be verified without a usable Git repository.

### Confirmed broken or incomplete behavior

- **Posts administration is not wired through.** The admin post service's update method prepares a URL and payload but does not send a request. The post create/update page is a placeholder and is not connected to the posts list. Backend post routes exist, but the Flutter admin UI does not provide working post create/update behavior. The root README currently describes post management screens, which overstates the working client behavior.
- **Public product ID parsing is incorrect.** `ProductResponse.fromJson` assigns `category_id` to `productId` instead of reading the product's `id`. The product detail page then uses that field to infer the category label, so the label depends on a product ID being confused with a category ID.
- **The Flutter widget test is stale.** `frontend/test/widget_test.dart` is the generated counter test, but `MyApp` starts the Sculpture Shop and has no counter UI. It does not test the current application and is expected to fail against the current app. Tests were not run during this audit.
- **The described project scope exceeds the implemented purchase flow.** Cart/order/payment schema is present, but no checkout, payment, cart, or order API/UI flow was found. Do not present this as a working end-to-end ecommerce flow unless the missing implementation is supplied.
- **Current database state is unknown.** The seeder is present, but no database was accessed during this audit, so it is unknown whether migrations have been applied or demo rows exist in the configured database.

### Documentation and publishing gaps

- The root README does not follow the required A1 section order. It lacks the required role/period/status and links header, problem, screenshots/demo, key decisions, challenges, next improvements, full tech stack, learning section, and license section. It also lacks the CI badge and A3 social post snippet.
- `docs/architecture.md` exists and describes the main Flutter/API/MySQL relationship. There is no `docs/images/` screenshot directory.
- No root `LICENSE` or `.github/workflows/ci.yml` was found.
- The README documents the local demo account password, which must be corrected as part of the secrets/documentation cleanup.

### Code-standard gaps

- Several Laravel model class names use underscores (for example, `Product_category`, `Order_item`, and `User_payment`), which conflicts with B2's `PascalCase` class naming. Renames need care because Laravel derives table names from model names.
- Flutter file names include non-snake-case names such as `shop-products-tile.dart` and `blog-posts-tile.dart`; several model folders are misspelled `entitiy`.
- There is commented-out implementation and debug-print code in the post controller, plus unused/incomplete post-editing code. These conflict with B3's dead-code/debug-leftover rule.
- Some public classes and methods do not have the short doc comments required by A2. The app has `flutter_lints`, but analyzer/formatter status was not checked during this audit.
- Existing TODO comments remain in platform scaffolding, including Android release signing/application ID setup and generated Linux Flutter files. They need to be distinguished from project-owned TODOs during cleanup.

### Testing and CI gaps

- Existing tests are framework examples rather than tests for product models, API parsing, authentication, admin product operations, or role changes. The minimum per-service/per-model coverage in B7 is not met.
- No CI workflow was found. Lint, formatting, clean-clone setup, secrets scanning, and the full test suite have not been verified in this audit.
- Dependency lockfiles are present for Flutter and Composer.

## Audit limits and TODOs

- **TODO — role:** Confirm whether the portfolio role is Solo or Team (and team size). The About page currently credits multiple contributors, so the prompt placeholder cannot be resolved from the supplied details alone.
- **TODO — dates:** Confirm the month range within 2025 for the README's required period field.
- **TODO — project scope:** Confirm whether the intended archived-project description is the implemented storefront/admin/API with ecommerce schema, or whether checkout/order functionality exists elsewhere and should be restored. The current code review found no working checkout flow.
- **TODO — demo credential:** Decide whether the local demo admin should be retained with a locally configured password or removed. The current fixed password must not remain in public documentation or be reused outside local development.
- **TODO — Git/backup:** Restore valid Git metadata or choose a backup method before any step that deletes original files; the C2 backup requirement cannot currently be met with a branch or tag.
- **TODO — database target:** Confirm which local database should receive the seed data and ensure it is available before any database-writing step. No database contents were read or changed during this audit.
- **TODO — portfolio links/media:** Supply any live-demo/repository/video links and screenshots to use in the README, or confirm that those fields should say they are unavailable for this archived project.

## Step 1 disposition

Audit complete. No application code, configuration, database, or existing documentation was changed. This file is the only audit-stage addition. Stop here for review, as required by C1.
