# Phase 1 implementation notes

**Working branch:** `work/phase-1-core-integrity`  
**Base:** `master` at `23b2323933f9a58b9ba7338b48887d80b57d7db8`  
**Status:** Implementation changes staged on the working branch; runtime and integration verification pending.

## 1.1 Authentication and authorization

- Registration now validates email and bounded profile fields, requires a confirmed password with a 12-character mixed-case, numeric, and symbol policy, and persists only validated fields.
- Public registration does not accept a role. The database default remains `user`; administrator role changes stay behind the administrator middleware.
- Login uses the same generic credential error for unknown emails and wrong passwords and returns HTTP 401. Login and registration routes are rate-limited.
- Passport personal-access tokens created by `createToken()` expire after 30 days. OAuth access tokens created through the authorization-code flow use a two-hour expiry; refresh tokens use 30 days.
- Flutter stores the access token using `flutter_secure_storage`, restores it before routing, and verifies it against the authenticated `/api/v1/me` endpoint. Logout revokes the server token when reachable and clears local session state.
- The `admins` table is retained as legacy data. A migration copies administrator identities into `users` by email and remaps post authors to the shared `users` identity. It does not drop the legacy table.
- Role management retains self-demotion and last-administrator safeguards.

**Platform note:** Linux secure storage requires a working Secret Service/libsecret installation. Web secure storage requires a secure context (HTTPS in production). The Flutter dependency has been added to `pubspec.yaml`; `pubspec.lock` still needs regeneration with `flutter pub get`.

## 1.2 Editorial data

- Post authors now reference `users`; legacy administrator records are migrated by email before the foreign key is changed.
- `published` is nullable: null means draft, a timestamp means published.
- Public post listing filters out drafts. The protected administrator listing includes both drafts and published posts.
- Create/update validation checks category existence, unique slugs, content limits, and publication timestamps. The server derives `author_id` from the authenticated administrator; client-supplied author IDs are ignored.
- Update/delete operations use not-found responses for missing records and successful updates return HTTP 200.
- The Flutter admin screen now supports create, edit, publish/unpublish, delete, category selection, and pagination.
- `PostCategorySeeder` supplies initial editorial categories when `php artisan db:seed` is run.

## 1.3 Products and API consistency

- Product inventory is enforced as one-to-one. The migration duplicates shared inventory rows while preserving each product's quantity before adding a unique constraint.
- Product creation/update validate SKU, category, inventory ownership, price, and non-negative quantity.
- Deleting a product removes its owned inventory row. Reassigning inventory releases the previous row.
- A quantity of zero is treated as a real update, not as a missing value.
- Product and post API resources provide stable field shapes and Laravel pagination metadata. Flutter now reads nested resource metadata and exposes pagination in the public catalog and administrator product/post lists.
- Product cards use the category supplied by the API rather than inferring category from a product ID.

### Price/currency data remains unresolved

The agreed product currency is USD, but the existing seed catalog stores values such as `24500000` and the UI labels them as Toman. No conversion or relabeling was applied: doing so without an approved USD price list or an explicit conversion policy would corrupt the meaning of existing prices. Before the USD release, replace/convert the seed and stored price data and centralize USD formatting.

## 1.4 Cart, order, and payment schema

The existing `cart_items`, `orders`, `order_items`, `shopping_sessions`, and `user_payments` tables are retained as legacy/incomplete schema. No complete cart, checkout, order, or payment API/UI flow was found in the reviewed implementation. They are not Phase 1 deliverables under the agreed portfolio scope. Do not describe purchase or payment as functional, and do not delete these tables until actual database contents and dependencies have been checked.

## Verification still required

Automated backend and Flutter tests have been added, but have **not** been executed in this environment. The available runtime has PHP CLI but no Composer installation or PDO SQLite driver; Flutter and Dart SDKs are also unavailable. Consequently:

- Run `composer install`, `php artisan migrate:fresh --env=testing`, `php artisan test`, and Pint in a PHP/Laravel environment.
- Run `flutter pub get` to resolve and commit the secure-storage lockfile changes, then `dart format`, `flutter analyze`, and `flutter test`.
- Test the author-migration path against a disposable copy of a database containing real legacy `admins` and `posts` rows before using it on retained data.
- Verify Passport key/client setup and token expiry in a running environment.
- Test Linux Secret Service and HTTPS web storage on the actual target platforms.

Until those checks pass, Phase 1 is **implemented but not accepted as complete**.
