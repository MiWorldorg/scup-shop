# Phase 3 implementation notes

**Branch:** \`work/phase-3-ui-responsive\`  
**Parent:** \`work/phase-2-architecture-review\`  
**Status:** Implementation in progress; final acceptance pending the project-wide QA pass.

## Design system and responsive foundation

- Reworked the dark charcoal, warm gold, and teal palette into semantic colors for primary, secondary, surfaces, muted text, borders, errors, and success.
- Expanded the typography scale with display, headline, title, body, and label styles; kept the bundled Noto Serif Display font for editorial headings and Roboto for body text.
- Added shared spacing, radius, breakpoint, content-width, and motion tokens.
- Centralized responsive page gutters and aligned Flutter responsive breakpoints around mobile, tablet, desktop, and wide desktop widths.
- Standardized Material 3 form fields, buttons, focus/error states, snackbars, tooltips, and minimum tap targets.
- Added meaningful image semantic labels where content images are displayed and disabled carousel/landing motion when the platform requests reduced animations.

## Public storefront

- Reworked the landing page's fixed-height editorial section to size to its content on narrow screens.
- Removed unsupported operational promises from the home page FAQ and feature cards (for example, delivery and support guarantees).
- Refined the brand story and footer to avoid unverified personal names, addresses, and phone numbers.
- Changed public navigation's admin entry to lead to the sign-in screen.
- Added server-backed product search and category filtering. The API now exposes public product categories and accepts optional \`category_id\` and \`search\` query parameters.
- Preserved pagination metadata in the public blog repository/controller and added journal pagination controls.
- Added semantic labels to product, article, gallery, and brand imagery.

## Admin experience

- Reworked the dashboard shell to use a fixed-width desktop navigation rail and a mobile drawer.
- Made product/post list headers and admin content spacing adapt to narrow viewports.
- Consolidated post row actions into a compact menu to avoid narrow-screen overflow.
- Added product and post cover image previews to the existing asset-path editors.
- Kept existing pagination, user search/role filters, destructive confirmations, and role-change confirmation behavior.

## Contact form and email workflow

- Added \`POST /api/v1/contact\` with request validation, a five-per-minute rate limit, and a honeypot field.
- The backend sends a plain-text email through Laravel's configured mail transport, using the visitor's address as \`Reply-To\`.
- Added a Flutter contact service and injected it through the application composition root.
- The contact page now submits to the API, disables duplicate submissions while sending, and displays success only after the API accepts the request.
- Required runtime configuration:
  - \`CONTACT_TO_ADDRESS\`: destination mailbox.
  - \`MAIL_MAILER=smtp\`, \`MAIL_HOST\`, \`MAIL_PORT\`, \`MAIL_USERNAME\`, \`MAIL_PASSWORD\`, \`MAIL_ENCRYPTION\`, and \`MAIL_FROM_ADDRESS\`.
- \`.env.example\` contains placeholders only. SMTP delivery has not been verified; do not describe email delivery as operational until real environment values are configured and a final integration check succeeds.

## Known decision required before currency acceptance

The agreed release currency is USD, but the current database schema stores a bare integer \`price\` with no currency field, and the existing product seeder uses values such as \`24,500,000\` while the UI labels them Toman. No approved exchange-rate source, conversion date, or rounding policy is recorded. Phase 3 deliberately does not relabel or convert those values. The USD display/data migration remains blocked until the owner provides an approved conversion basis or confirms that the database values have already been converted.

## Verification policy

Per owner instruction, Flutter format/analyzer/tests/builds and Laravel Pint/tests/migrations/API checks remain deferred until all implementation phases are complete. No test, build, SMTP-delivery, or runtime pass is claimed in these notes.
