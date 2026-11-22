# Sculpture Shop

Sculpture Shop is a responsive storefront and admin dashboard built as a university web development project. The client is written in Flutter, and a Laravel REST API provides product, post, user, and authentication endpoints.

The existing visual design, colors, spacing, and page structure are retained. The interface copy is in English, with a display serif for major headings and a sans serif for body text.

## Features

- Responsive home page, product catalog, blog, gallery, and contact page
- Product, post, and user management screens
- Laravel JSON API with Laravel Passport authentication
- MySQL schema managed through Laravel migrations

## Repository layout

```text
sculpture-shop/
├── backend/             # Laravel API
├── docs/                # Project and database notes
└── frontend/            # Flutter application
```

See [the architecture notes](docs/architecture.md) and [database guide](docs/database.md) for more detail.

## Requirements

- PHP 8.3–8.5, Composer, and the PHP `sodium` and `pdo_mysql` extensions
- MySQL 8 or MariaDB
- Flutter 3.32 or later with Dart 3.8 or later

## Run the API

```bash
cd backend
cp .env.example .env
composer install
php artisan key:generate
```

Create a MySQL database named `sculpture_shop`, then update the `DB_*` values in `.env`. Run the migrations and prepare Passport:

```bash
php artisan migrate --seed
php artisan passport:install
php artisan serve
```

The API is available at `http://127.0.0.1:8000/api/v1/`. To seed a local administrator account, set a private `DEMO_ADMIN_PASSWORD` value in `backend/.env` before running `php artisan migrate --seed`. The local admin email is `admin@example.test`; use it to open `/admin/login` in the Flutter app. The demo account is created only in the local environment.

## Run the Flutter app

In a second terminal:

```bash
cd frontend
flutter pub get
flutter run -d chrome
```

The default API address is `http://127.0.0.1:8000/api/v1/`. To point the client at another API, pass its base URL at build or run time:

```bash
flutter run -d chrome --dart-define=API_BASE_URL=https://api.example.com/api/v1/
```

The base URL must end with `/`. Android emulators use `http://10.0.2.2:8000/api/v1/` by default. For a physical device, pass an API address reachable on its network.

## API routes

Public catalog routes:

- `GET /api/v1/product`
- `GET /api/v1/post`

Management routes are grouped under `/api/v1/admin/` for products, posts, and users; they require an administrator bearer token. The Flutter client provides an Admin sign in link in the storefront footer. For local development, sign in with the seeded demo administrator described above. In other environments, create an account through the registration API, then promote its `users.role` to `admin` using the setup instructions in [backend/README.md](backend/README.md). The Users & roles screen can assign or remove administrator access.

## Typography

The Flutter theme uses Noto Serif Display for a cinematic feel in large headings and Roboto for body copy. The font's SIL Open Font License is included with the font in `frontend/assets/fonts/NotoSerifDisplay/`.

## Project status

This repository contains the application source, migrations, demo product seed data, and setup notes. Local credentials, dependency caches, generated build output, and the old database export are excluded. The blog starts empty and can be populated through its database tables.
