# Laravel API

This Laravel application serves the Scup-Shop JSON API. Configure the database in `.env`, then run:

Use PHP 8.3–8.5 with the `sodium` and `pdo_mysql` PHP extensions enabled. The dependency set targets Laravel 13.

```bash
composer install
php artisan key:generate
php artisan migrate --seed
php artisan passport:install
php artisan serve
```

The local seeder creates five sample products, the `Sculptures` and `Collectibles` product categories, and the initial editorial categories. To create the optional local demo administrator, set a private `DEMO_ADMIN_PASSWORD` value in `.env` before running the seeder. The demo customer account is also optional and uses `DEMO_CUSTOMER_PASSWORD`. Both accounts are seeded only in the local environment.

See the root [README](../README.md) for the complete setup and API routes.

## Administrator access

When `APP_ENV=local` and `DEMO_ADMIN_PASSWORD` is configured, the seeded `admin@example.test` account can sign in with the password you supplied. Storefront registrations receive the `user` role. In other environments, register the account, then promote it from Tinker:

```bash
php artisan tinker
```

```php
App\Models\User::where('email', 'owner@example.com')->update(['role' => 'admin']);
```

The Flutter admin sign-in screen is available at `/admin/login`. Management API routes require a Passport bearer token from `POST /api/v1/login` and an account with the `admin` role. The Users & roles screen can then grant or remove administrator access. Seeded accounts are for local development only.

## Security configuration

- Public registration cannot assign a role. It creates a regular `user` account; promote an administrator only through the protected role-management path or a controlled deployment operation.
- Personal access tokens issued by `createToken()` expire after 30 days. Logout revokes the current token. Run `php artisan passport:install` and complete any personal-access-client setup requested by Passport before testing login.
- In production, API requests over plain HTTP are rejected. Set `APP_ENV=production`, `APP_DEBUG=false`, and an HTTPS `APP_URL`.
- Set `CORS_ALLOWED_ORIGINS` to a comma-separated allowlist containing the exact deployed Flutter Web origin(s). CORS credentials are disabled.
- If the API is behind a reverse proxy/load balancer, set `TRUSTED_PROXIES` to the proxy IPs/CIDRs so Laravel can recognize the original HTTPS scheme. Do not trust arbitrary forwarded headers from untrusted clients.
- Production session cookies default to Secure and remain HttpOnly. The Flutter API uses bearer tokens, not browser cookies.

## Tests

Backend feature tests use an in-memory SQLite database. Install the `pdo_sqlite` extension in addition to the production extensions, then run:

```bash
php artisan test
vendor/bin/pint --test
```

The migration that moves post authors from the legacy `admins` table into `users` must be tested against a disposable database copy containing representative existing admin and post rows before applying it to retained data. Do not test that migration first on the only copy of production data.
