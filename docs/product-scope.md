# Product Scope

## Product goal

Scup-Shop is a portfolio-quality sculpture storefront, editorial site, and administration/API demonstration. It is not currently a full e-commerce system.

## Implemented in source (runtime verification pending)

- Public landing, about, gallery, contact, product catalog, and editorial pages.
- Responsive Flutter layouts targeting Android, Web, Windows, and Linux.
- Public product search, category filtering, pagination, and stock display.
- Public published-post listing and pagination.
- Passport authentication and secure client token persistence.
- Administrator product CRUD, post CRUD/publishing, user listing, and role management.
- Contact form endpoint with validation, rate limiting, honeypot validation, and configurable Laravel Mail transport.
- USD demo catalog with whole-dollar sample prices and a reversible data migration.

"Implemented in source" describes repository implementation, not a claim that all platforms, integrations, or runtime flows have passed QA. Contact email delivery specifically requires real SMTP configuration and inbox verification.

## Explicitly out of scope

- Shopping cart UI and cart operations.
- Checkout and order placement.
- Payment provider integration or payment processing.
- Customer order history and fulfillment.
- Arbitrary product/post file uploads; current editors select bundled asset paths.
- iOS and macOS targets for this project phase.

Legacy database tables for cart, shopping sessions, orders, order items, and payment metadata are retained but are not wired into an active purchase flow.

## Decisions

- Shared Flutter codebase across Android, Web, Windows, and Linux.
- English user interface.
- USD display currency; product prices are whole-dollar integers in the current schema.
- Five demo product prices are illustrative portfolio values, not external valuations.
- Public blog posts are readable; administrators manage post content and publication.
- Contact messages are sent through configured email and are not stored in the database.
- Repository remains private; no license file is included until ownership and asset rights are reviewed.

## Operational dependencies

- MySQL database and Laravel environment configuration.
- Passport client setup for API authentication.
- CONTACT_TO_ADDRESS and a real MAIL_* configuration for contact delivery.
- Platform-specific Flutter tooling and plugin configuration for target builds.

## Current release blockers

- Full Flutter/Laravel tests, formatting, analysis, and platform builds.
- Visual and accessibility review at agreed viewport sizes.
- Real SMTP delivery verification.
- Clean-clone setup verification and final documentation review.
