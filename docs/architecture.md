# Scup-Shop Architecture

## System context

Scup-Shop is a portfolio-focused sculpture storefront and administration application. The current runtime consists of one Flutter client, a versioned Laravel JSON API, and a MySQL database. The public catalog, editorial blog, admin CRUD, and contact-message workflow are in scope. A transactional checkout/payment flow is intentionally not part of the product.

    Visitor / Admin
          |
          v
    Flutter client
          | HTTPS JSON /api/v1
          v
    Laravel 13 API ---------> Configured Laravel Mail transport
          |
          v
        MySQL

The contact form posts to the API. Laravel validates and rate-limits the request, then attempts to send a plain-text email through the configured mail transport. Contact messages are not persisted in a database table. Actual SMTP delivery is not yet verified.

## Flutter application

### Composition and startup

- frontend/lib/main.dart initializes Flutter, restores the secure token store, registers shared dependencies, restores the authenticated profile, and starts the widget tree.
- frontend/lib/app/app_bindings.dart is the composition root for shared dependencies. It registers the shared ApiClient, feature services, repository implementations behind domain contracts, and the long-lived authentication controller.
- Route bindings create presentation controllers for the route that owns them. Dashboard sub-pages are registered by the dashboard binding.
- Pages consume controllers through GetX bindings. They should not instantiate controllers, repositories, or HTTP services.

### Dependency direction

    Presentation page / widget
              |
              v
        GetX controller
              |
              v
       Domain repository contract
              ^
              | implemented by
        Data repository
              |
              v
         Feature service
              |
              v
          ApiClient
              |
              v
          Laravel API

The intended dependency direction is Presentation → Domain contract, with Data implementing that contract. The data layer owns transport details and DTO parsing; controllers coordinate state and user intents; widgets render state and forward events.

### Shared API transport and authentication

- core/api/api_client.dart owns the shared GetConnect transport, API base URL, request timeout, Accept header, and optional bearer-token attachment.
- Feature services pass endpoint constants and typed query/body values to the client; they do not construct their own HTTP clients or repeat base-URL/header logic.
- core/api/api_response.dart owns response-envelope parsing, pagination metadata, HTTP failure conversion, and user-safe error messages.
- core/api/api_session.dart owns secure token persistence through flutter_secure_storage and the in-memory view of the current session.
- core/api/endpoints.dart is the endpoint-name registry; core/api/url.dart resolves the configured API origin.
- Passport personal access tokens expire after 30 days. Logout revokes the current token.

Configure the API origin at build time with --dart-define=API_BASE_URL=https://api.example.com/api/v1/. Local defaults are intended for development only.

### Feature ownership

- features/authentication/: sign-in state and authentication repository contract.
- features/public/shop/: public product catalog, search, categories, pagination, and stock display.
- features/public/blog/: public published editorial content and pagination.
- features/public/landing_page/: composition of public product and editorial state.
- features/admin_panel/products/: product administration.
- features/admin_panel/posts/: editorial administration.
- features/admin_panel/users/: user listing and administrator-role management.
- features/public/contact/: contact form and API submission.
- features/public/gallery/, about_us/: public presentation features.

### Flutter conventions

- File names use Dart snake_case.dart; types use UpperCamelCase; members use lowerCamelCase.
- GetX is the selected navigation, state-management, and dependency-management approach.
- Route-scoped controllers are created in route bindings; shared dependencies are registered in AppBindings.
- Controllers depend on domain repository contracts, not concrete data implementations.
- Feature services use the shared ApiClient; response parsing is centralized.
- Keep UI widgets free of direct network, database, and service construction.

## Laravel API

### Request flow

    Versioned API route
           |
           v
    Authentication / admin middleware
           |
           v
    Form Request validation
           |
           v
    Thin API controller
       /         \
      v           v
    Action     Read repository
      \           /
       v         v
       Eloquent models / transactions
                  |
                  v
             API Resources
                  |
                  v
            JSON response

- routes/api.php defines the versioned API surface.
- Passport middleware authenticates protected routes; the admin middleware enforces the administrator role.
- Form Requests validate write input at the HTTP boundary.
- Controllers coordinate request/response behavior.
- Application actions own multi-step write use cases and transaction boundaries.
- Repository contracts/implementations own reusable read-query composition.
- Eloquent models own relationships and persistence mapping.
- API Resources define stable product, post, and user response shapes.
- bootstrap/app.php maps API validation, authentication, authorization, and not-found exceptions to a consistent JSON envelope; web routes retain Laravel's normal exception rendering.

### Current action/repository boundaries

- Actions/Admin/ManageProducts owns product creation/update/deletion and inventory transactions.
- Actions/Admin/ManagePosts owns post create/update/delete use cases.
- Actions/Admin/ChangeUserRole owns role-change invariants, including stale-actor checks, self-demotion prevention, and last-administrator protection.
- Actions/Auth/AuthenticateUser and Actions/Auth/RegisterUser own credential verification, safe account creation, and Passport token issuance.
- Product, post, and user repository contracts return paginated query results; controllers apply API Resources and build the JSON envelope.
- ContactController validates through ContactMessageRequest, checks CONTACT_TO_ADDRESS, and attempts a plain-text email via Laravel Mail. Delivery errors return 503; the endpoint does not store submissions.

### Container bindings

AppServiceProvider binds repository contracts to their Eloquent-backed implementations. Controllers request contracts, not concrete repository classes. Application actions are resolved through Laravel's container.

### Backend conventions

- Use PSR-4 namespaces and Laravel's standard directory ownership.
- Form Requests validate every write endpoint.
- Controllers return explicit JSON response types/status codes and API Resources.
- Put transaction boundaries around multi-row operations in an application action.
- Repositories should not mix unrelated write workflows, request validation, and HTTP response formatting.
- Preserve legacy table/column names where renaming would create unnecessary migration risk.

## Security and deployment boundaries

- Flutter stores Passport access tokens using flutter_secure_storage and sends them as bearer tokens for protected requests.
- Production API traffic must use HTTPS; the API middleware rejects plain HTTP in production.
- Set CORS_ALLOWED_ORIGINS to the exact deployed Flutter Web origins.
- Set TRUSTED_PROXIES only to actual reverse-proxy addresses/CIDRs.
- Configure CONTACT_TO_ADDRESS and a real MAIL_* transport for contact email. The example values are placeholders.
- Do not commit runtime secrets. Supply deployment-specific configuration through environment variables or secret management.
- Do not log access tokens, passwords, or unnecessary personal data.

## Explicit scope boundaries

- The current product is a portfolio-quality storefront/admin/API demonstration.
- Cart, checkout, order processing, and payment processing are not implemented, despite legacy schema tables.
- Product prices are whole-dollar USD sample values stored in the integer products.price column.
- The contact endpoint attempts email delivery but does not persist messages; SMTP delivery requires deployment configuration and verification.
- Target platforms are Android, Web, Windows, and Linux. Platform builds remain unverified pending the final QA phase.

## Follow-ups

- Complete automated coverage and platform builds in Phase 5.
- Configure and verify real SMTP delivery.
- Capture screenshots and perform keyboard, screen-reader, contrast, and text-scaling review.
