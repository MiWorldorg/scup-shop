# Changelog

All notable project changes are documented here. The project is in development; no stable release has been tagged.

## Unreleased

### Added
- Responsive Flutter storefront and administrator interface targeting Android, Web, Windows, and Linux.
- Public product catalog search, category filters, pagination, stock display, and whole-dollar USD demo pricing.
- Public editorial listing and admin post management.
- Admin product management, user listing, and role management.
- Contact form API endpoint with validation, honeypot field, rate limiting, and configurable Laravel Mail transport.
- Shared Flutter API client, GetX application composition, repository contracts, and Laravel application actions.
- API response security headers, query indexes for known filters/sorts, and operational backup/restore guidance.
- Flutter and Laravel test coverage additions and a manual-only GitHub Actions quality/build workflow.
- Architecture, database, API, product-scope, accessibility, operations, and testing documentation.

### Changed
- Reworked semantic theme colors, typography, spacing, responsive gutters, and reduced-motion behavior.
- Updated the five portfolio demo catalog prices to illustrative whole-dollar USD values through a reversible migration and matching seeder values.
- Improved async-state semantics and dark-theme contrast.

### Known limitations
- Cart, checkout, order placement, and payment processing are not implemented.
- Contact messages are not stored; actual email delivery requires real SMTP configuration and inbox verification.
- Arbitrary image upload is not implemented; admin image selection uses bundled asset paths.
- Automated tests, formatters, analyzers, and target builds have not yet been executed.
- No live demo or final runtime screenshots are available.
- Repository remains private and has no LICENSE file by owner decision.
