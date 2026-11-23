# Flutter Client

The Flutter application contains the public Scup-Shop storefront, editorial pages, contact form, and protected administrator screens. One shared codebase targets Android, Web, Windows, and Linux.

## Requirements

- Flutter 3.32 or later
- Dart 3.8 or later
- Platform tooling for the target you want to run

## Install and run

From this directory:

    flutter pub get
    flutter run -d chrome

The app uses GetX for routing, feature state, and dependency composition. The shared API transport is in lib/core/api/api_client.dart; endpoint names are in lib/core/api/endpoints.dart.

## API configuration

The default API origin is selected in lib/core/api/url.dart:

- Android emulator: http://10.0.2.2:8000/api/v1/
- Web, Windows, Linux, and other local targets: http://127.0.0.1:8000/api/v1/

Override the API origin at build/run time:

    flutter run -d chrome --dart-define=API_BASE_URL=https://api.example.com/api/v1/

The configured URL must end with a slash. Physical devices need a host address reachable on their network. The backend must be running and configured separately; see [backend setup](../backend/README.md).

## Authentication

Passport access tokens are persisted with flutter_secure_storage. Protected API calls attach the bearer token through the shared ApiClient. The token lifetime is controlled by the backend (currently 30 days); signing out revokes the active token.

## Feature map

- lib/features/public/shop/: catalog, search, category filters, stock, pagination, product detail.
- lib/features/public/blog/: published journal list and post detail.
- lib/features/public/contact/: contact form submission.
- lib/features/admin_panel/products/: product administration.
- lib/features/admin_panel/posts/: editorial management.
- lib/features/admin_panel/users/: account listing and role management.
- lib/core/: API client, routes, theme, design tokens, and shared widgets.

Product prices are displayed as whole-dollar USD. Admin product image fields select bundled asset paths; arbitrary file uploads are not implemented.

## Platform and verification status

Android, Web, Windows, and Linux are the agreed target platforms. iOS and macOS are not current targets. Platform builds, accessibility, and runtime behavior have not yet passed the final QA phase.

Per the project owner's workflow, Flutter formatting, analysis, tests, and builds are deferred until all implementation phases are complete. The planned commands are:

    dart format .
    flutter analyze
    flutter test

See the root [README](../README.md), [API reference](../docs/api.md), and [architecture guide](../docs/architecture.md).
