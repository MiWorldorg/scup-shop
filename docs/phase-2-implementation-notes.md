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
  - `Actions/Admin/ManageProducts`: product writes, inventory updates, transactions, and legacy cart/order deletion guard.
  - `Actions/Admin/ManagePosts`: post create/update/delete.
  - `Actions/Admin/ChangeUserRole`: administrator authorization re-check, self-demotion rule, and last-admin invariant inside a transaction.
- Reduced product/post repositories to read-query responsibilities.
- Added dedicated Form Requests for product deletion, post deletion, and user-role updates.
- Kept controllers responsible for HTTP response envelopes/status codes and API Resources.
- Updated the stale-admin test to exercise the extracted role-change action.
- Documented the application-action boundary in ADR 0002.

## Deferred cleanup

- The legacy empty landing repository/service files and several non-standard file/folder names remain pending. They will not be deleted or renamed until a verified backup tag is available, as required by the repository safety checklist.
- Authentication token issuance/registration remains in `AuthRepositoryApi`; extracting it into dedicated authentication actions is a follow-up.
- Some feature screens/controllers may still need additional separation after the full codebase audit.
- No mass folder rename or database table/column rename was performed.

## Final QA gates (deferred)

Per owner instruction, the full automated test run is scheduled after the implementation phases are complete. Before Phase 2 can be accepted, final QA must include:

- Flutter format, analyzer, widget/unit tests, and builds for Android, Web, Windows, and Linux.
- Laravel Pint, feature/unit tests, migration/rollback checks, and API contract verification.
- Dependency registration/navigation smoke tests, including dashboard embedded pages and independent admin routes.
- Review of all remaining direct service/repository/controller construction and unused abstractions.
