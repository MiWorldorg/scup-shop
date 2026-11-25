# Scup-Shop

<p align="center">
  <img src="frontend/assets/images/sculpture-banner-1.png" alt="Classical sculpture artwork from the Scup-Shop collection" width="100%" />
</p>

<h1 align="center">SCUP-SHOP</h1>
<p align="center"><strong>A considered digital space for sculpture, art, and editorial storytelling.</strong></p>
<p align="center">
  <a href="#overview">Overview</a> · <a href="#experience">Experience</a> · <a href="#architecture">Architecture</a> · <a href="#getting-started">Getting started</a>
</p>

<p align="center">
  <img alt="Flutter" src="https://img.shields.io/badge/Flutter-3.32%2B-7B9BA6?style=flat-square&logo=flutter&logoColor=white">
  <img alt="Dart" src="https://img.shields.io/badge/Dart-3.8%2B-7B9BA6?style=flat-square&logo=dart&logoColor=white">
  <img alt="Laravel" src="https://img.shields.io/badge/Laravel-13-C49A6C?style=flat-square&logo=laravel&logoColor=white">
  <img alt="PHP" src="https://img.shields.io/badge/PHP-8.3--8.5-777BB4?style=flat-square&logo=php&logoColor=white">
  <img alt="Database" src="https://img.shields.io/badge/MySQL-compatible-8A8178?style=flat-square&logo=mysql&logoColor=white">
  <img alt="Status" src="https://img.shields.io/badge/Status-In%20development-B18A62?style=flat-square">
</p>

---

## Overview

**Scup-Shop** is a portfolio-focused sculpture storefront and editorial platform. It pairs a responsive Flutter application with a Laravel 13 JSON API to present a curated sculpture catalog, publish editorial content, and provide focused administration tools.

The visual direction takes cues from premium art galleries: restrained typography, warm stone and bronze tones, generous negative space, and artwork-led presentation.

> **Project status:** In development. This repository is private. A live demo has not been deployed, and final cross-platform screenshots and the complete automated quality pass are still pending.

## Experience

- **Discover:** browse sculptures with search, category filtering, stock information, and pagination.
- **Read:** explore published editorial posts.
- **Connect:** view brand and gallery information and submit a contact message.
- **Administer:** manage products, posts, and user roles through a protected admin area.
- **Adapt:** share a responsive Flutter codebase across Android, Web, Windows, and Linux targets.

### Scope, by design

This is an art and catalog presentation project, **not a completed commerce system**. Cart, checkout, order placement, and payment processing are not implemented. Legacy schema tables for those concepts are documented as unused by current user-facing flows.

## Architecture

```text
                 ┌─────────────────────────┐
                 │       Visitor/Admin     │
                 └────────────┬────────────┘
                              │
                 ┌────────────▼────────────┐
                 │     Flutter / Dart      │
                 │       GetX UI           │
                 └────────────┬────────────┘
                              │ HTTPS · JSON
                 ┌────────────▼────────────┐
                 │      Laravel 13 API     │
                 │ Passport · Actions      │
                 │ Requests · Resources    │
                 └───────┬─────────┬───────┘
                         │         │
                  ┌──────▼────┐ ┌──▼────────────┐
                  │   MySQL   │ │ Laravel Mail  │
                  └───────────┘ └───────────────┘
```

| Layer | Technology | Responsibility |
|---|---|---|
| Client | Flutter, Dart, GetX | Responsive multi-platform interface |
| API | Laravel 13, PHP | Versioned JSON endpoints and application workflows |
| Authentication | Laravel Passport | Bearer-token authentication and protected admin access |
| Persistence | MySQL / compatible MariaDB | Relational data, migrations, and seeders |
| Contact | Laravel Mail | Configurable contact-message delivery |

Architecture notes and decision records are available in [docs](docs/architecture.md) and [docs/decisions](docs/decisions/).

## Getting started

### Prerequisites

- PHP 8.3–8.5 with `sodium`, `pdo_mysql`, and `pdo_sqlite`
- Composer
- MySQL 8 or a compatible MariaDB release
- Flutter 3.32+ and Dart 3.8+
- Tooling for the target platform: Android, Chrome/Web, Windows, or Linux

### 1. Start the API

```bash
cd backend
cp .env.example .env
composer install
php artisan key:generate
```

Create a database and configure the `DB_*` values in `backend/.env`. Set a private `DEMO_ADMIN_PASSWORD` before seeding if you need the local demo admin account.

```bash
php artisan migrate --seed
php artisan passport:install
php artisan serve
```

The API base path is `http://127.0.0.1:8000/api/v1/`.

### 2. Start the Flutter client

In a second terminal:

```bash
cd frontend
flutter pub get
flutter run -d chrome
```

The default API URL lives in `frontend/lib/core/api/url.dart`. Override it when needed:

```bash
flutter run -d chrome --dart-define=API_BASE_URL=https://api.example.com/api/v1/
```

The URL must end with `/`. Android emulators generally use `10.0.2.2` to reach the host machine; physical devices need a reachable host address.

### Contact email

Configure `CONTACT_TO_ADDRESS` and valid `MAIL_*` values in `backend/.env`. The committed `.env.example` contains placeholders. SMTP delivery has not yet been verified.

## Quality and verification

The project includes backend and frontend tests plus a manual final-verification workflow. Per the project's agreed workflow, the complete test, formatter, analyzer, and platform-build pass is deferred until implementation is complete. **No passing CI or final QA result is claimed here.**

See the [testing plan](docs/testing.md), [release checklist](docs/release-checklist.md), and [master checklist](MASTER_CHECKLIST.md).

## Project documentation

- [Architecture](docs/architecture.md)
- [API reference](docs/api.md)
- [Database](docs/database.md)
- [Product scope](docs/product-scope.md)
- [Operations](docs/operations.md)
- [Accessibility](docs/accessibility.md)
- [Testing plan](docs/testing.md)
- [Decision records](docs/decisions/)
- [Changelog](CHANGELOG.md)
- [Release checklist](docs/release-checklist.md)
- [GitHub presentation guide](docs/github-presentation.md)
- [GitHub presentation guide](docs/github-presentation.md)

## Roadmap

- [ ] Complete automated tests, static analysis, and clean builds for all agreed targets.
- [ ] Verify contact email delivery with a real mail provider.
- [ ] Capture final Android, Web, Windows, and Linux screenshots.
- [ ] Publish a reviewable demo after runtime and security checks.
- [ ] Revisit licensing after ownership and third-party asset rights are reviewed.

## Project details

**Role:** Solo developer  
**Status:** In development  
**Repository visibility:** Private  
**Live demo:** Not deployed  
**License:** No license file is included; reuse and redistribution are not granted.

---

<p align="center"><strong>SCUP-SHOP</strong><br><sub>Art, presented with intention.</sub></p>
