# Laravel API

Scup-Shop's backend is a Laravel 13 JSON API. It provides public catalog/editorial endpoints, Passport authentication, administrator management endpoints, and a rate-limited contact-email endpoint.

## Requirements

- PHP 8.3–8.5
- Composer
- MySQL 8 or compatible MariaDB
- PHP extensions: sodium, pdo_mysql
- pdo_sqlite for the in-memory backend test database

## Local setup

1. Create a database and a dedicated local database user. Example SQL (choose your own local password):

    CREATE DATABASE sculpture_shop CHARACTER SET utf8mb4 COLLATE utf8mb4_unicode_ci;
    CREATE USER 'scup_user'@'127.0.0.1' IDENTIFIED BY 'replace-with-a-local-password';
    GRANT ALL PRIVILEGES ON sculpture_shop.* TO 'scup_user'@'127.0.0.1';
    FLUSH PRIVILEGES;

2. Copy the example environment file and install dependencies:

    cp .env.example .env
    composer install
    php artisan key:generate

3. Configure DB_CONNECTION, DB_HOST, DB_PORT, DB_DATABASE, DB_USERNAME, and DB_PASSWORD in .env.
4. Optionally set DEMO_ADMIN_PASSWORD and DEMO_CUSTOMER_PASSWORD for local-only seed accounts. Leave them blank to skip those accounts.
5. Run the schema and sample catalog seeders, prepare Passport, and start the server:

    php artisan migrate --seed
    php artisan passport:install
    php artisan serve

The API base path is http://127.0.0.1:8000/api/v1/.

The five demo product prices are whole-dollar USD sample values. Migration 2026_11_23_000003_replace_demo_product_prices_with_usd updates the five known demo SKUs in existing databases; ProductSeeder uses the same values.

## Contact email

The public endpoint is POST /api/v1/contact. It validates the sender fields, enforces a 5-per-minute rate limit, checks a honeypot field, and attempts to send a plain-text email.

Configure all of the following in .env:

- CONTACT_TO_ADDRESS: destination inbox.
- MAIL_MAILER=smtp
- MAIL_HOST, MAIL_PORT
- MAIL_USERNAME, MAIL_PASSWORD
- MAIL_ENCRYPTION
- MAIL_FROM_ADDRESS and optionally MAIL_FROM_NAME

The values in .env.example are placeholders and do not provide a working SMTP service. The endpoint returns HTTP 503 when the destination is missing or sending fails. HTTP 202 indicates that the configured mail transport accepted the send request; it does not prove final inbox delivery. Messages are not stored in the database.

## Administrator access

When APP_ENV=local and DEMO_ADMIN_PASSWORD is configured, the seeder creates admin@example.test with the supplied password. Seeded accounts are for local development only.

Public registration always creates a regular user. In a controlled environment, an initial administrator can be promoted through a trusted deployment operation:

    php artisan tinker

    App\Models\User::where('email', 'owner@example.com')->update(['role' => 'admin']);

The Flutter admin sign-in screen is available at /admin/login. Protected management endpoints require a Passport bearer token and the admin role. The Users & roles screen can then grant or remove administrator access subject to server-side safeguards.

## Security configuration

- Public registration cannot assign a role.
- Passport personal access tokens expire after 30 days; logout revokes the current token.
- In production, API requests over plain HTTP are rejected. Set APP_ENV=production, APP_DEBUG=false, and an HTTPS APP_URL.
- Set CORS_ALLOWED_ORIGINS to a comma-separated allowlist of exact deployed Flutter Web origins.
- If the API is behind a reverse proxy/load balancer, set TRUSTED_PROXIES to actual proxy IPs/CIDRs.
- Do not commit .env or real credentials. Keep secrets in environment configuration or a secret manager.

## API and schema documentation

- Endpoint methods, authentication, payloads, response envelopes, and status codes: [docs/api.md](../docs/api.md).
- Tables, relationships, legacy schema, and seed/migration behavior: [docs/database.md](../docs/database.md).
- Runtime and layer responsibilities: [docs/architecture.md](../docs/architecture.md).
- Deployment, backup, restore, and migration operations: [docs/operations.md](../docs/operations.md).

## Tests and quality checks

Backend feature tests use an in-memory SQLite database. Once the implementation phases are complete, run:

    php artisan test
    vendor/bin/pint --test

The full test and static-quality pass is intentionally deferred until the final verification phase. The migration that moves post authors from the legacy admins table into users must be validated against a disposable database copy containing representative legacy rows before it is applied to retained data.
