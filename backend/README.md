# Laravel API

This Laravel application serves the Sculpture Shop JSON API. Configure the database in `.env`, then run:

Use PHP 8.3–8.5 with the `sodium` and `pdo_mysql` PHP extensions enabled. The dependency set targets Laravel 13.

```bash
composer install
php artisan key:generate
php artisan migrate --seed
php artisan passport:install
php artisan serve
```

The local seeder creates five sample products and the `Sculptures` and `Collectibles` categories. To create the optional local demo administrator, set a private `DEMO_ADMIN_PASSWORD` value in `.env` before running the seeder. The demo customer account is also optional and uses `DEMO_CUSTOMER_PASSWORD`. Both accounts are seeded only in the local environment.

See the root [README](../README.md) for the complete setup and the API routes.

## Administrator access

When `APP_ENV=local` and `DEMO_ADMIN_PASSWORD` is configured, the seeded `admin@example.test` account can sign in with the password you supplied. Storefront registrations receive the `user` role. In other environments, register the account, then promote it from Tinker:

```bash
php artisan tinker
```

```php
App\Models\User::where('email', 'owner@example.com')->update(['role' => 'admin']);
```

The Flutter admin sign-in screen is available at `/admin/login`. Management API routes require a Passport bearer token from `POST /api/v1/login` and an account with the `admin` role. The Users & roles screen can then grant or remove administrator access. Seeded accounts are for local development only.
