# Phase 2 — Architecture and code structure implementation notes

**Working branch:** `work/phase-2-architecture`  
**Base:** Phase 1 draft branch `work/phase-1-core-integrity-review`  
**Status:** Implementation in progress; runtime acceptance and final tests are deferred to the project's final QA pass by owner instruction.

## Flutter changes

- Added `core/api/api_client.dart` as the shared GetConnect transport with one API base URL, a 20-second request timeout, standard JSON Accept header, and optional active/explicit bearer token support.
- Migrated the public catalog, public blog, admin products, admin posts, admin users, and authentication services to the shared API client.
- Added `app/app_bindings.dart` as the application composition root for the API client, feature services, repository contracts/implementations, and the global authentication controller.
- Changed repository implementations to receive their services through constructors rather than instantiate services internally.
- Changed authentication controller to depend on the authentication repository contract.
- Changed feature route bindings to resolve repositories from the application container.
- Removed direct controller/repository construction from the landing, product, post-management, and user-management page widgets.
- Made the landing controller explicitly compose the product and editorial controllers used by the landing page.
- Added a user-management binding and ensured the dashboard binding registers the controllers used by the dashboard's embedded users/products/posts pages.
- Documented the dependency direction and composition decision in `docs/architecture.md` and ADR 0001.

## Laravel changes

- Cleaned repository contracts and removed unused imports and unrelated method declarations.
- Bound authentication, post, product, and user repository contracts to their implementations in `AppServiceProvider`.
- Changed API controllers to request repository contracts rather than concrete repository classes.
- Added application actions:
  - `Actions/Auth/AuthenticateUser` and `Actions/Auth/RegisterUser`: credential verification, safe registration, and token issuance.
  - `Actions/Admin/ManageProducts`: product writes, inventory updates, transactions, and legacy cart/order deletion guard.
  - `Actions/Admin/ManagePosts`: post create/update/delete.
  - `Actions/Admin/ChangeUserRole`: administrator authorization re-check, self-demotion rule, and last-admin invariant inside a transaction.
- Reduced product/post repositories to read-query responsibilities.
- Added dedicated Form Requests for product deletion, post deletion, and user-role updates.
- Kept controllers responsible for HTTP response envelopes/status codes and API Resources.
- Updated the stale-admin test to exercise the extracted role-change action.
- Documented the application-action boundary in ADR 0002.

## Deferred cleanup

- Created and verified a recovery branch, `backup/phase-2-pre-cleanup`, before the cleanup batch. (A formal backup tag is still not available through the current repository integration.)
- Normalized non-snake-case Dart file names, corrected the About Us controller typo, flattened the nested user service directory, normalized Contact binding/controller directory names, and moved the post list card into its owning feature.
- Removed the unused duplicate user repository contract, duplicate user card, and empty landing data-layer scaffolding.
- Extracted authentication registration/token issuance into `AuthenticateUser` and `RegisterUser`; active auth routes no longer use the legacy auth repository.
- Kept the six feature `data/entity/` directories consistently as the current DTO/entity namespace rather than performing a broader rename with no functional benefit.
- No database table/column rename was performed.

## Final QA gates (deferred)

Per owner instruction, the full automated test run is scheduled after the implementation phases are complete. Before Phase 2 can be accepted, final QA must include:

- Flutter format, analyzer, widget/unit tests, and builds for Android, Web, Windows, and Linux.
- Laravel Pint, feature/unit tests, migration/rollback checks, and API contract verification.
- Dependency registration/navigation smoke tests, including dashboard embedded pages and independent admin routes.
- Review of all remaining direct service/repository/controller construction and unused abstractions.
