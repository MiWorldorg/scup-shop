# Scup-Shop

> A portfolio-focused sculpture storefront and editorial platform with a responsive Flutter client and a Laravel API for catalog and content administration.

**Role:** Solo developer · **Period:** Not specified · **Status:** In development

**Links:** [Private GitHub repository](https://github.com/MiWorldorg/Scup-Shop) · Live demo: not deployed · Screenshots: pending final runtime capture

> This repository is private. No CI badge is shown because a CI workflow has not yet been added. The project is not licensed for redistribution; no LICENSE file is included by owner decision.

---

## 1. Problem

Independent sculpture and art collections need a clear way to present individual pieces and related editorial content, while keeping catalog and publishing tasks manageable. Scup-Shop explores that experience for visitors and a small administrator team without pretending to be a complete commerce platform.

## 2. Solution

Scup-Shop combines a public Flutter storefront with a Laravel 13 JSON API and an administrator area.

- Browse a sculpture catalog with search, category filters, stock information, and pagination.
- Read published editorial posts.
- Explore the brand, gallery, and contact information.
- Sign in to the protected admin area to manage products, posts, and user roles.
- Submit a contact message through the Flutter form to a rate-limited Laravel endpoint. The endpoint uses the configured Laravel mail transport; actual email delivery still requires deployment-specific SMTP settings and final verification.

**Explicit scope:** cart, checkout, order placement, and payment processing are not implemented. Legacy database tables for those concepts remain in the schema and are documented as unused by the current user-facing flows.

## 3. Screenshots / Demo

No screenshots are published yet. Final captures will be added after the agreed Android, Web, Windows, and Linux visual review and runtime QA. A live demo is not currently deployed.

## 4. Architecture

    Visitor / Admin
          |
          v
    Flutter client
          | HTTPS JSON /api/v1
          v
    Laravel 13 API ---------> Configured mail transport
          |
          v
        MySQL

- **Frontend:** Flutter / Dart, GetX for navigation, state, and dependency composition.
- **Backend:** Laravel 13 JSON API, Laravel Passport bearer-token authentication.
- **Database:** MySQL, managed by Laravel migrations and seeders.
- **Email:** Laravel Mail transport, configured through environment variables.
- **Platforms targeted:** Android, Web, Windows, and Linux. Platform builds and runtime behavior remain subject to final QA.

See [architecture](docs/architecture.md), [database](docs/database.md), and [API reference](docs/api.md).

## 5. Key Decisions & Trade-offs

- **One Flutter codebase:** shared screens and responsive layouts reduce duplicated UI work across the agreed targets; platform-specific plugins still require platform validation.
- **GetX composition and state:** GetX provides routing, bindings, and feature controllers in one consistent approach; adding a second state framework would increase maintenance cost.
- **Laravel actions for writes and repositories for reads:** multi-row write workflows and transaction boundaries stay out of HTTP controllers, while read queries remain reusable and paginated.
- **Portfolio scope rather than checkout:** catalog, editorial, administration, and contact demonstrate the intended product surface without presenting incomplete order/payment tables as a working commerce flow.
- **Whole-dollar USD demo prices:** sample product prices are explicit portfolio values, not converted legacy prices or market valuations.

Decision records are in [docs/decisions](docs/decisions/).

## 6. Challenges & How I Solved Them

- **Mixed responsibility in API code:** separated validation, controllers, application actions, repository contracts, and API resources.
- **Inconsistent client dependencies:** introduced a shared API client and an application composition root so feature services use one transport configuration.
- **Responsive admin controls:** adapted navigation and list actions for narrow screens, and added bundled-asset selection with previews rather than implying arbitrary file upload support.
- **Legacy schema beyond current scope:** kept unused order/cart tables documented instead of exposing non-working checkout features.

## 7. What I'd Improve Next

- Complete automated test coverage, static analysis, and clean platform builds for all agreed targets.
- Configure a real mail provider and verify contact delivery end to end.
- Capture final screenshots and deploy a reviewable demo after the runtime and security checks.
- Consider a transactional commerce workflow only as a separately scoped future phase.

## 8. Tech Stack

Flutter · Dart · GetX · Laravel 13 · PHP · Laravel Passport · MySQL · REST API

## 9. Getting Started

### Requirements

- PHP 8.3–8.5 with sodium, pdo_mysql, and pdo_sqlite for the backend test suite.
- Composer.
- MySQL 8 or a compatible MariaDB release.
- Flutter 3.32+ and Dart 3.8+.
- Android, Chrome/Web, Windows, or Linux tooling for the target you intend to run.

### Configure and run the API

1. Create a MySQL database named sculpture_shop.
2. Configure the backend environment:

    cd backend
    cp .env.example .env
    composer install
    php artisan key:generate

3. Set DB_* values in backend/.env. For local admin access, set a private DEMO_ADMIN_PASSWORD before seeding. The seeder only creates demo accounts in the local environment.
4. Run migrations, seed the demo catalog, prepare Passport, and start Laravel:

    php artisan migrate --seed
    php artisan passport:install
    php artisan serve

The API base path is http://127.0.0.1:8000/api/v1/.

### Configure and run Flutter

In a second terminal:

    cd frontend
    flutter pub get
    flutter run -d chrome

The default API URL is configured in frontend/lib/core/api/url.dart. Override it when needed:

    flutter run -d chrome --dart-define=API_BASE_URL=https://api.example.com/api/v1/

The URL must end with /. Android emulators generally need to reach the host through 10.0.2.2; physical devices need a host address reachable on their network. For Windows and Linux, use the API host reachable from that machine.

### Contact email configuration

To enable the contact mail workflow, configure CONTACT_TO_ADDRESS and valid MAIL_* values in backend/.env. The committed .env.example contains placeholders, not working credentials. The endpoint returns a service-unavailable response when the destination is missing or sending fails. SMTP delivery has not yet been verified.

### Tests and quality checks

Per the project owner's workflow, the complete test, formatter, analyzer, and build pass is deferred until implementation phases are complete. Do not interpret the absence of a failing result as a passing result. The final commands and coverage plan are tracked in the master checklist.

## 10. Project Structure

    Scup-Shop/
    ├── backend/                 # Laravel API, actions, requests, resources, migrations
    ├── frontend/                # Flutter app, features, shared UI, assets
    ├── docs/
    │   ├── decisions/           # Architecture decision records
    │   ├── images/              # Final portfolio screenshots (to be captured)
    │   ├── api.md               # Endpoint reference
    │   ├── architecture.md      # Runtime and dependency architecture
    │   └── database.md          # Schema and ER diagram
    ├── MASTER_CHECKLIST.md      # Phase plan and acceptance tracking
    └── portfolio-project-standard.md

## 11. What I Learned

The implementation provides practical work across Flutter responsive UI, dependency composition, API contract design, Laravel authorization and transaction boundaries, relational data integrity, and documenting the limits of a legacy schema. The final quality and platform claims remain open until the planned verification phase is complete.

## License

No license file is included. The repository remains private and reuse or redistribution is not granted. Licensing can be revisited after ownership and third-party asset/content rights are reviewed.
