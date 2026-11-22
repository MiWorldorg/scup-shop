# Scup-Shop — Master Project Checklist

> The single execution checklist for bringing Scup-Shop to a reliable, maintainable, well-documented, portfolio-ready state. Work in small, reviewable phases. Do not mark an item complete until its acceptance criteria are verified.

**Repository:** `MiWorldorg/Scup-Shop`  
**Baseline reviewed:** `master` at `23b2323933f9a58b9ba7338b48887d80b57d7db8`  
**Checklist branch:** `docs/master-project-checklist`  
**Review date:** 2026-11-23  
**Current implementation:** Flutter client + Laravel 13 API + MySQL + Laravel Passport  
**Status:** Planning / audit follow-up — no application code changed as part of this checklist.

---

## How to use this checklist

- [ ] Work phase by phase in the order below; do not start a later phase while a blocking decision from an earlier phase is unresolved.
- [ ] Each implementation task gets a focused branch/commit or a small logical commit.
- [ ] Add tests with bug fixes and behavior changes; do not defer all tests to the end.
- [ ] Keep this file updated in the same change that completes each meaningful task.
- [ ] A task is complete only when its acceptance criteria pass locally and, where applicable, in CI.
- [ ] Do not delete or rename existing code until a verified backup/tag exists and references have been searched.
- [ ] Do not add features merely to make the project look larger. The README must distinguish implemented, incomplete, and planned behavior.

### Priority definitions

- **P0 — Blocker:** security, data integrity, broken core behavior, or decisions that determine the architecture.
- **P1 — High:** required for a reliable and coherent application.
- **P2 — Medium:** maintainability, usability, performance, and portfolio quality.
- **P3 — Polish:** optional refinements after core quality is established.


## Phase 0 — repository baseline update (2026-11-23)

### Verified remotely
- Repository is private, active (not archived), and its default branch is `master`.
- Current `master` baseline: `23b2323933f9a58b9ba7338b48887d80b57d7db8` (`Initial Commit`, 2026-11-22).
- GitHub currently exposes one commit in the repository history. This means there is no earlier repository history available through the current GitHub API view to inspect.
- Branches currently visible: `master` and `docs/master-project-checklist`; both report unprotected.
- No Git tags are currently visible.
- No `.github/workflows/` files are present in the recursive repository tree.
- Recursive tree scan found `backend/.env.example` as the only environment-file match; no tracked `.env`, database dump, SQLite database, private-key file, `vendor/`, Flutter `build/`, or `.dart_tool/` path was found.
- Root `.gitignore` excludes environment files other than `.env.example`, Laravel vendor/cache/log paths, Flutter build/cache paths, and common OS/log files.
- `backend/.env.example` contains blank database password and blank optional demo-password values; it contains no populated credential value.
- README currently describes a responsive storefront/admin dashboard, product/post/user management screens, Passport authentication, and local setup. It does not claim checkout/payment is complete; the blog starts empty.
- Runtime baseline (Flutter analyzer/tests/build, Pint/PHPUnit, migrations, Passport setup) has not been run. GitHub file access alone cannot establish whether those commands pass.

### Phase 0 gate status
- [x] Confirm remote default branch, current commit, visible branch list, and available commit history.
- [x] Check visible tags and whether the default branch is protected.
- [x] Inspect tracked-path inventory for obvious environment files, database exports, private-key files, and generated dependency/build directories.
- [ ] Create a backup tag before the first destructive cleanup/rename. No destructive work is authorized or underway; create it immediately before that phase.
- [ ] Complete a content-level secrets scan across all tracked files and the available commit history. The path scan above is not a secrets scan.
- [ ] Run a clean-clone setup and all baseline commands in a real local/dev environment.
- [ ] Capture current UI screenshots at the agreed target breakpoints.
- [ ] Confirm product scope and platform targets with the project owner.

### Owner decisions still required
The next blocking decision is the product goal: should Scup-Shop remain a portfolio-quality demonstration of the currently implemented storefront/admin/API, or should the roadmap target a genuinely operational online shop with cart, checkout, orders, and payment integration? This decision changes the data model, API scope, security work, test plan, UI flows, and delivery estimate.


---

# Phase 0 — Baseline, scope, and safe working process

## 0.1 Confirm project scope and product decisions

- [ ] **P0** Confirm whether this repository is an archived university project to be polished as-is, or a product intended to become a functioning online shop.
- [ ] **P0** Decide the intended delivery target: Flutter Web only, Android/iOS, desktop, or a defined combination. Do not promise all Flutter platforms just because scaffold folders exist.
- [ ] **P0** Decide whether checkout, cart, orders, and payment are in scope. Current evidence shows schema tables, but no complete customer-facing cart/checkout/payment/order workflow.
- [ ] **P0** Decide whether the blog is intended to be editable by administrators or remain read-only/static for this release.
- [ ] **P1** Confirm whether contact messages should be sent through a real backend/email workflow or whether the page should remain informational. Current UI explicitly tells the visitor that online sending is unavailable.
- [ ] **P1** Confirm the product's actual audience, currency, locale, and language policy. The current interface is English and product form labels use Toman.
- [ ] **P1** Confirm project role (solo/team), team size if applicable, and exact project period before publishing portfolio claims.

**Acceptance:** A short product-scope decision is recorded in `docs/product-scope.md`; every planned feature has one of: implemented, in-scope to build, explicitly out-of-scope.

## 0.2 Repository safety and baseline

- [ ] **P0** Confirm the Git history and working branch locally; record the actual current commit and branch.
- [ ] **P0** Create and verify a backup tag before any destructive cleanup or broad renaming.
- [ ] **P0** Confirm that no real `.env`, credential, token, database dump, or generated build output is tracked in any branch/history.
- [ ] **P1** Run a clean-clone setup from documented instructions on a fresh environment.
- [ ] **P1** Record baseline outputs for `flutter analyze`, `dart format --output=none --set-exit-if-changed .`, Laravel Pint, and PHPUnit.
- [ ] **P1** Capture the current screens at mobile, tablet, and desktop widths before redesign, so behavior and visual regressions can be compared.
- [ ] **P2** Record baseline bundle/build sizes and key page/API timings before optimization.

**Acceptance:** Backup is verifiably recoverable; baseline commands and screenshots are recorded; no destructive change is made before this gate.

---

# Phase 1 — P0 correctness, security, and data integrity

## 1.1 Authentication and authorization

- [ ] **P0** Review registration validation: require valid email, bounded strings, unique email, and a strong minimum password policy; return field-level validation errors.
- [ ] **P0** Ensure registration uses only validated input, never unrestricted `$request->all()`.
- [ ] **P0** Add feature tests proving a public registration can never assign the admin role.
- [ ] **P0** Review token issuance, expiry/revocation, and Passport configuration; document the actual token lifecycle.
- [ ] **P0** Replace the in-memory-only Flutter token session with secure persistence appropriate to the selected platforms; clear it on logout and handle expired/revoked tokens.
- [ ] **P0** Ensure protected API routes reject missing, invalid, expired, and non-admin tokens with consistent status codes.
- [ ] **P0** Review role changes, including self-demotion and last-admin protection, under concurrent requests; add tests for each invariant.
- [ ] **P1** Add rate limiting to login and registration endpoints and verify generic login errors do not reveal whether an email exists.
- [ ] **P1** Review CORS, HTTPS-only production configuration, cookie/token exposure, logging, and sensitive-field serialization.
- [ ] **P1** Confirm admin accounts are managed through one identity model; avoid maintaining separate, conflicting admin and user authentication systems.

## 1.2 Posts/editorial data integrity

- [ ] **P0** Resolve the current identity mismatch: `posts.author_id` has a foreign key to `admins`, while login, roles, and admin management operate on `users`. Choose one author identity model and migrate safely.
- [ ] **P0** Ensure post create validation matches the schema and business rules: author/category existence, unique slug, title/summary/content limits, publication state/date, and required image behavior.
- [ ] **P0** Fix post update handling for nonexistent IDs; it currently dereferences a possibly-null model after lookup.
- [ ] **P0** Correct the successful post-update HTTP status (the current success response is returned with status 400).
- [ ] **P0** Use validated payloads for post create/update and return consistent not-found/validation responses.
- [ ] **P0** Add integration tests for list, create, update, delete, invalid category/author, duplicate slug, and missing post.
- [ ] **P1** Complete the Flutter admin post workflow: create, edit, publish/unpublish, delete, validation, loading, success/error feedback.
- [ ] **P1** Add pagination support to the post administration UI or explicitly limit the dataset with a documented rule.
- [ ] **P1** Verify public blog only exposes posts intended to be public/published; do not leak drafts.

## 1.3 Product, inventory, and API correctness

- [ ] **P0** Add backend feature tests for product create/update/delete, category validation, SKU uniqueness, and inventory quantity behavior.
- [ ] **P0** Decide whether inventory is one-to-one with products; enforce that invariant in database constraints and application logic.
- [ ] **P0** Ensure product deletion and inventory deletion/update behavior cannot leave orphaned or shared inventory records.
- [ ] **P1** Remove product-category inference based on product ID in the storefront card; use the actual category returned by the API and a neutral fallback.
- [ ] **P1** Add pagination metadata to the shared Flutter API result and wire pagination/load-more into storefront and admin product lists. Current screens request a page but discard page metadata and do not advance.
- [ ] **P1** Normalize API response envelopes and HTTP status codes across controllers; avoid a mix of 200/201/400 for equivalent operations.
- [ ] **P1** Add API resources/DTOs so database models are not serialized inconsistently or exposed directly.
- [ ] **P1** Validate image paths/URLs and define a real upload/storage contract before supporting arbitrary images.
- [ ] **P2** Define price representation and currency centrally; avoid ambiguous integer formatting and hard-coded currency labels in widgets.

## 1.4 Cart, order, and payment schema decision

- [ ] **P0** Review all existing cart/order/payment migrations against the agreed product scope before implementing anything.
- [ ] **P0** If checkout is out of scope, label these tables as unused legacy schema and document that no purchase flow exists.
- [ ] **P0** If checkout is in scope, redesign the order lifecycle, price snapshots, stock reservation/decrement, idempotency, transaction boundaries, and failure/rollback behavior before UI work.
- [ ] **P0** Do not store raw card numbers, CVVs, or other payment credentials. Use a compliant external payment provider if payments are ever implemented.
- [ ] **P1** Add foreign-key/index/nullability review and migration tests for the complete schema.
- [ ] **P1** Confirm migration order and rollback safety on a disposable test database.

**Acceptance for Phase 1:** Core auth, product, editorial, and schema invariants are covered by automated tests; the admin author relationship is unambiguous; no known P0 data-integrity/security issue remains.

---

# Phase 2 — Architecture and code structure

## 2.1 Flutter architecture

- [ ] **P1** Keep the current feature-first direction, but document one consistent module contract for every feature: `presentation/`, `domain/`, and `data/` only where each layer is genuinely needed.
- [ ] **P1** Standardize feature names and directory spelling (for example, `entity` → `models` or `dto` consistently); use Dart `snake_case.dart` file names.
- [ ] **P1** Move misplaced feature files into their owning feature; avoid admin product files containing post widgets and deeply nested duplicate user-service folders.
- [ ] **P1** Establish a single app composition point for dependency registration. Avoid constructing services/repositories inside page widgets or calling `Get.put` from `GetView` field initializers.
- [ ] **P1** Keep GetX for this modernization unless a measured requirement justifies migration; do not mix state-management approaches.
- [ ] **P1** Define boundaries: widgets render state and emit intents; controllers coordinate UI state; repositories abstract feature data; services own HTTP; models/DTOs parse and serialize.
- [ ] **P1** Consolidate duplicated API calls and error handling in a typed API client with shared base URL, headers, timeouts, auth interceptor, and response parsing.
- [ ] **P1** Introduce typed paginated results and explicit loading/empty/error/success states; avoid repeating ad-hoc response parsing in each service.
- [ ] **P1** Make dependency injection testable by injecting interfaces/fakes rather than instantiating concrete services in repositories.
- [ ] **P2** Separate navigation route definitions from feature implementation details and document route guards.
- [ ] **P2** Remove empty abstractions and pass-through repositories only when they provide a real testability or domain boundary benefit.
- [ ] **P2** Add structured logging and avoid silent catch blocks or swallowed failures.

## 2.2 Laravel architecture

- [ ] **P1** Standardize namespaces, casing, model names, and file names; use Laravel conventions and explicit table names where legacy schema requires them.
- [ ] **P1** Define a simple, consistent request path: Route → Form Request → Controller → Application Service/Action → Eloquent Model → API Resource.
- [ ] **P1** Decide whether repository classes provide meaningful abstraction. Remove pass-through layers or give them explicit contracts; avoid repositories that mix persistence, validation, and HTTP response formatting.
- [ ] **P1** Move business rules and multi-step transactions out of controllers into focused application services/actions.
- [ ] **P1** Use dedicated Form Requests for every write endpoint; tighten validation types, max lengths, existence checks, and authorization.
- [ ] **P1** Use Laravel API Resources for stable response contracts and prevent accidental field exposure.
- [ ] **P1** Define consistent exception handling and API error envelope/status semantics.
- [ ] **P2** Add model relationships, casts, scopes, and factories where they clarify actual domain behavior.
- [ ] **P2** Remove unused imports, stale comments, dead code, and inconsistent formatting; document non-obvious business rules rather than narrating obvious code.

## 2.3 Proposed target layout (guideline, not a mass-move instruction)

```text
Scup-Shop/
├── README.md
├── LICENSE
├── MASTER_CHECKLIST.md
├── .editorconfig
├── .gitignore
├── .github/workflows/
├── docs/
│   ├── product-scope.md
│   ├── architecture.md
│   ├── api.md
│   ├── database.md
│   ├── decisions/
│   └── images/
├── frontend/
│   ├── lib/
│   │   ├── app/                 # app bootstrap, routing, dependency setup
│   │   ├── core/                # API client, config, theme, shared UI
│   │   └── features/
│   │       ├── catalog/
│   │       ├── blog/
│   │       ├── authentication/
│   │       ├── admin/
│   │       └── contact/
│   └── test/
└── backend/
    ├── app/
    │   ├── Http/                # controllers, requests, resources
    │   ├── Actions/             # focused use cases (if useful)
    │   ├── Models/
    │   └── Support/
    ├── database/
    ├── routes/
    └── tests/
```

- [ ] **P1** Approve the target layout and mapping from every current folder before moving files.
- [ ] **P1** Rename in small batches and update imports, routes, autoloading, and tests in the same commit.
- [ ] **P1** Do not rename database tables or columns just to satisfy naming style; use explicit model table mappings and a migration plan if schema changes are justified.

**Acceptance:** Architecture diagram matches the actual implementation; each feature has clear ownership; dependency direction is documented; no page constructs its own network stack or bypasses the intended layer.

---

# Phase 3 — UI/UX redesign and responsive experience

## 3.1 Design system

- [ ] **P1** Audit current screens and agree on a visual direction before coding. Preserve the sculpture/art identity, but establish a consistent, accessible design system.
- [ ] **P1** Define design tokens for color, typography, spacing, radius, elevation, borders, breakpoints, and motion.
- [ ] **P1** Rework the current dark charcoal / warm gold / teal palette into a deliberate semantic color system with verified contrast. Do not use color as the only status signal.
- [ ] **P1** Define typography scale, readable body sizes, line lengths, heading hierarchy, and font fallback.
- [ ] **P1** Standardize buttons, text fields, dropdowns, cards, dialogs, chips, tables/lists, snackbars, empty states, and loading states.
- [ ] **P1** Add focus, hover, pressed, disabled, error, and success states for interactive components.
- [ ] **P1** Verify keyboard navigation, screen-reader labels/semantics, text scaling, and contrast.

## 3.2 Public storefront

- [ ] **P1** Redesign the home page around a clear value proposition, strong sculpture photography, featured collection, category discovery, editorial content, and one primary call to action.
- [ ] **P1** Redesign the catalog with consistent product imagery/aspect ratios, category filters, sorting/search if in scope, price formatting, and pagination/load-more.
- [ ] **P1** Redesign product detail to show complete product information, gallery, category, availability, price, and clear next action. Do not imply add-to-cart or purchase behavior until implemented.
- [ ] **P1** Redesign blog cards and article detail with readable editorial typography, image treatment, publication metadata, and responsive content width.
- [ ] **P2** Refine gallery browsing, image viewing, and mobile interactions.
- [ ] **P1** Make the contact page honest and functional: either connect a real message endpoint or clearly present available contact methods. Never display a success state for a message that was not sent.
- [ ] **P2** Review navigation, footer, active states, mobile drawer, and page-to-page consistency.

## 3.3 Admin experience

- [ ] **P1** Redesign the admin shell with clear information hierarchy, consistent sidebar/header, active navigation, and responsive mobile navigation.
- [ ] **P1** Build reusable data-list patterns with search/filter, pagination, loading, empty, error, and retry states.
- [ ] **P1** Improve product forms: validation summaries, category loading/errors, image selection/preview, price/stock fields, and save feedback.
- [ ] **P1** Complete and redesign post authoring/editing only after the backend author/category model is fixed.
- [ ] **P1** Make role changes clear and deliberate, with confirmation and visible permission consequences.
- [ ] **P2** Replace placeholder dashboard metrics/activity with real, clearly defined data or remove decorative/unsupported metrics.
- [ ] **P2** Add destructive-action confirmation and consistent success/error feedback across all admin operations.

## 3.4 Responsive and visual QA

- [ ] **P1** Define supported widths and test narrow mobile, large mobile, tablet, laptop, and wide desktop.
- [ ] **P1** Fix overflow, clipped dialogs, fixed-width assumptions, grid density, and long text behavior.
- [ ] **P1** Verify images have meaningful alt/semantic labels where relevant and use optimized assets.
- [ ] **P2** Add image size optimization and caching; consider WebP/AVIF variants where platform support and source assets permit.
- [ ] **P2** Add subtle, purposeful motion and respect reduced-motion/accessibility expectations.

**Acceptance:** Approved screen designs exist before implementation; all core flows work at agreed breakpoints; no major overflow/accessibility regression remains; screenshots document the final design.

---

# Phase 4 — Documentation and open-source presentation

## 4.1 README and project docs

- [ ] **P1** Rewrite root README to follow `portfolio-project-standard.md` section order and accurately describe the real scope.
- [ ] **P1** Add role, period, status, repository/demo/media links, and a CI badge only when the workflow exists.
- [ ] **P1** Add problem, solution, screenshots/demo, architecture, key decisions/trade-offs, challenges, future improvements, tech stack, getting started, project structure, learning, and license sections.
- [ ] **P1** Clearly state that checkout/payment/order workflows are not implemented if they remain out of scope.
- [ ] **P1** Clearly state that contact form submission is unavailable unless a real backend workflow is added.
- [ ] **P1** Update backend and frontend READMEs so setup steps, versions, routes, environment variables, and commands are accurate and non-duplicative.
- [ ] **P1** Expand `docs/architecture.md` with a diagram, module responsibilities, request flow, auth flow, and deployment boundaries.
- [ ] **P1** Expand `docs/database.md` with ER diagram, table purpose, relationships, indexes, migration/seed behavior, and known unused schema.
- [ ] **P1** Add `docs/api.md` documenting endpoint, method, auth requirement, request schema, response schema, pagination, and error codes.
- [ ] **P1** Add `docs/product-scope.md` recording implemented/out-of-scope/planned features and decisions.
- [ ] **P2** Add short ADRs in `docs/decisions/` for meaningful choices such as state management, API response format, auth token storage, and order-flow scope.
- [ ] **P1** Add curated screenshots to `docs/images/` with captions and no personal or sensitive data.
- [ ] **P1** Add a root LICENSE only after the owner confirms the intended license and has the right to license included assets/content.
- [ ] **P2** Add contribution guidance, issue templates, and a concise code-of-conduct only if the project is being opened to outside contributions.
- [ ] **P2** Add a LinkedIn/Wellfound post snippet based on verified project facts.

## 4.2 Documentation quality gate

- [ ] **P1** Verify every README feature claim against a working route/screen and tests.
- [ ] **P1** Verify all setup commands on a clean clone.
- [ ] **P1** Search docs and examples for credentials, personal data, obsolete routes, and contradictory instructions.
- [ ] **P2** Add a glossary for domain terms where it improves onboarding.

**Acceptance:** A new developer can understand the product, architecture, setup, test commands, API, and current limitations without asking for undocumented information.

---

# Phase 5 — Tests, static analysis, security checks, and CI

## 5.1 Flutter tests and quality

- [ ] **P1** Replace the starter widget test with meaningful app smoke tests.
- [ ] **P1** Expand model/DTO parsing tests for missing, null, malformed, and valid payloads.
- [ ] **P1** Add API client/service tests using fakes or mocks; cover success, validation errors, unauthorized, server errors, and network failures.
- [ ] **P1** Add controller tests for loading, retry, stale-request handling, pagination, and error states.
- [ ] **P1** Add widget tests for login, product list/form, user role management, and contact behavior.
- [ ] **P1** Add integration tests for the critical agreed end-to-end flows.
- [ ] **P1** Run `dart format .` and `flutter analyze`; resolve all project-owned warnings/errors and document any justified exceptions.
- [ ] **P2** Review dependency health and remove unused packages only after checking actual usage.

## 5.2 Laravel tests and quality

- [ ] **P1** Add feature tests for authentication, authorization, product CRUD, inventory, user role changes, and post endpoints.
- [ ] **P1** Add tests for database constraints, transactions, pagination, and API resource shapes.
- [ ] **P1** Add unit tests for non-trivial business rules and validation boundaries.
- [ ] **P1** Run PHPUnit and Laravel Pint; resolve project-owned failures.
- [ ] **P1** Add static analysis appropriate to the codebase and enforce a documented baseline.
- [ ] **P2** Add factories and reusable test fixtures; ensure tests use isolated disposable databases.

## 5.3 CI and repository automation

- [ ] **P1** Add `.github/workflows/ci.yml` for Flutter format/analyze/test and Laravel install/Pint/test.
- [ ] **P1** Pin supported runtime versions and cache dependencies safely.
- [ ] **P1** Ensure CI uses test-only environment variables and disposable databases; never expose production secrets.
- [ ] **P1** Add dependency/security scanning and secret scanning appropriate to repository visibility.
- [ ] **P1** Make required checks pass before merge.
- [ ] **P2** Add build jobs only for platforms the project explicitly supports.
- [ ] **P2** Add release/versioning guidance if releases are planned.

**Acceptance:** A clean checkout passes CI; test suites exercise the real critical flows; no known failing starter test or unverified quality claim remains.

---

# Phase 6 — Performance, accessibility, and operational readiness

- [ ] **P1** Profile startup, navigation, image loading, large lists, and API latency before optimizing.
- [ ] **P1** Add server-side pagination and query limits to every potentially unbounded list.
- [ ] **P1** Check Eloquent query counts and eager-load relationships to prevent N+1 queries.
- [ ] **P1** Add appropriate database indexes for filters, sorting, foreign keys, and unique business keys.
- [ ] **P1** Set production-safe Laravel configuration: debug off, HTTPS, secure headers, trusted hosts/proxies, logs, and error reporting.
- [ ] **P1** Document backup/restore and migration deployment procedures.
- [ ] **P2** Add caching only for data with clear invalidation rules.
- [ ] **P2** Review Flutter image memory use, asset sizes, and lazy loading.
- [ ] **P2** Verify accessibility with keyboard-only use, screen reader, contrast checks, and text scaling.
- [ ] **P2** Add basic operational health checks and structured logs without logging secrets or personal data.

**Acceptance:** Performance changes are backed by measurements; production settings are documented; backup/restore and migration procedures are rehearsed in a non-production environment.

---

# Phase 7 — Final release and portfolio readiness

- [ ] **P1** Run the complete test/format/analyzer/CI suite from a clean clone.
- [ ] **P1** Verify all links, screenshots, badges, environment examples, and setup instructions.
- [ ] **P1** Perform a final secrets and dependency audit, including history where available.
- [ ] **P1** Verify that the README accurately labels all incomplete or excluded functionality.
- [ ] **P1** Prepare a concise changelog/release note and tag only a verified stable state.
- [ ] **P2** Capture final desktop/mobile screenshots and a short demo of real working flows.
- [ ] **P2** Prepare a truthful portfolio summary and LinkedIn post based on verified work and confirmed role/dates.
- [ ] **P2** Review open issues and leave a prioritized, realistic next-step backlog.

**Definition of done:** The project builds from a clean clone, core flows are tested, CI is green, docs match implementation, the UI is coherent and responsive, no known critical security/data-integrity issue remains, and portfolio claims are evidence-based.

---

# Current code-review notes (baseline findings)

These are observations from the current repository snapshot, not claims that tests or runtime verification have been performed.

## Confirmed from source

- Flutter uses GetX for routing/state and a feature-oriented folder layout, but dependency creation is inconsistent: some pages instantiate controllers/repositories directly.
- The shared API response parser supports Laravel pagination internally, but list consumers commonly call the non-paginated list helper; product/blog/admin-post screens do not currently expose pagination controls.
- The admin post UI is incomplete: the create/edit page is a placeholder; the list has no connected create/edit/delete flow. The service contains an update method, but no visible UI path invokes it.
- The Laravel post update repository can dereference a missing post and returns HTTP 400 even on its success path.
- The post author foreign key references `admins`, while application authentication and role management use `users`. This is a schema/domain mismatch requiring an explicit decision.
- Contact form submission is not connected to a backend; the UI explicitly tells the visitor that no message was sent.
- Cart/order/payment-related migrations and models exist, but no complete customer checkout/order/payment workflow was found in the reviewed routes and Flutter feature tree.
- The Flutter auth token is held in a static in-memory `ApiSession`; persistence across app restarts is not implemented there.
- The root README is more concise than the required portfolio README structure and does not currently include screenshots, CI badge, full decision/challenge sections, or license section.
- The current product parser correctly reads `json['id']` for `productId`; the older AUDIT.md claim that it reads `category_id` is stale. However, the storefront product card and product-detail page still infer category labels from `productId == 1` instead of using the API's `categoryName`.
- Root `.gitignore` excludes environment files, Flutter build/cache directories, and Laravel vendor/cache paths. Tracking/history still needs an explicit audit before destructive cleanup.
- The current root README and backend README use environment-configured local demo passwords; the older AUDIT.md statement that fixed demo passwords are in the current README is stale. Verify the full Git history and all tracked files before declaring secrets clean.

## Needs runtime verification

- [ ] Run Flutter analyzer, formatter, unit/widget tests, and builds on the agreed target platforms.
- [ ] Run Laravel Pint, PHPUnit, migrations, and seeders against a disposable test database.
- [ ] Verify Passport installation/configuration on a clean setup.
- [ ] Verify all API routes against actual request/response behavior.
- [ ] Inspect all tracked files and repository history for secrets and generated artifacts.
- [ ] Test the UI at supported breakpoints; source inspection alone is not a visual QA pass.
- [ ] Confirm whether the currently documented local setup works end-to-end on a clean machine.

---

## Decisions and change log

| Date | Decision / update | Owner | Status |
| --- | --- | --- | --- |
| 2026-11-23 | Created the master checklist from repository source review; no application code changed. | Project | Draft for review |

