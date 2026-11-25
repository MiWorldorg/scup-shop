# Operations and Deployment Notes

This guide describes a cautious deployment path for the Laravel API and Flutter client. No production deployment is currently configured or verified.

## Production environment

Set deployment-specific values through the host's secret/configuration manager. Do not commit a populated .env file.

Minimum Laravel settings:

- APP_ENV=production
- APP_DEBUG=false
- APP_URL=https://your-api-host.example
- APP_KEY: generated once and stored securely
- DB_*: production database connection
- CORS_ALLOWED_ORIGINS: exact Flutter Web origins, comma-separated
- TRUSTED_PROXIES: only the real reverse proxy IPs/CIDRs, if applicable
- MAIL_MAILER, MAIL_HOST, MAIL_PORT, MAIL_USERNAME, MAIL_PASSWORD, MAIL_ENCRYPTION, MAIL_FROM_ADDRESS
- CONTACT_TO_ADDRESS: intended contact inbox

The API rejects non-HTTPS requests in production. Configure TLS at the edge/reverse proxy and ensure Laravel receives the original HTTPS scheme from a trusted proxy. Do not trust arbitrary forwarded headers.

API responses include baseline security headers. Strict-Transport-Security is added only in production when the request is recognized as secure. Validate proxy/TLS behavior before relying on HSTS.

## Health check and logs

Laravel exposes the framework health route at /up. Configure the deployment platform's health probe to call it over HTTPS.

The application uses Laravel's configured logging channel. Set an appropriate production LOG_LEVEL, retain logs according to the hosting policy, and ensure log collection does not expose passwords, bearer tokens, mail credentials, or unnecessary personal data.

## Database backup

Before every production schema/data migration, take a consistent backup. For MySQL, a typical operator-run command is:

    mysqldump --single-transaction --routines --triggers --user="$DB_USERNAME" --password --host="$DB_HOST" --port="$DB_PORT" "$DB_DATABASE" > scup-shop-before-migration.sql

The password option prompts for the database password; do not put the password directly in shell history or command arguments.

Verify that the backup exists and is non-empty:

    test -s scup-shop-before-migration.sql
    sha256sum scup-shop-before-migration.sql

Store the backup in a protected location separate from the application host. Encrypt it at rest and restrict access.

## Restore rehearsal

Restore into a disposable database, not over the only copy of production data:

    mysql --user="$DB_USERNAME" --password --host="$DB_HOST" --port="$DB_PORT" "$RESTORE_DATABASE" < scup-shop-before-migration.sql

Then verify expected tables and representative rows. Record the restore duration and any manual steps. A backup is not considered operationally useful until restoration has been rehearsed.

## Migration deployment sequence

1. Review the exact migration diff and its down() behavior.
2. Back up the database and verify the backup file.
3. Apply the release to a staging environment with a recent sanitized database copy.
4. Run migrations and inspect affected records, indexes, and API behavior.
5. Schedule a maintenance window if the migration or deployment requires write downtime.
6. Deploy the backend code and install production dependencies.
7. Run the migration command with explicit production intent:

       php artisan migrate --force

8. Verify /up, authentication, public catalog, admin access, and contact mail behavior.
9. Exit maintenance mode if it was enabled:

       php artisan up

10. Keep the pre-deployment backup until the release is accepted and the rollback window expires.

Do not blindly run migrate:rollback after a failed data migration. Determine whether a down() migration is safe for the current data state; restoring the verified backup may be the safer recovery path.

## Data migrations that need special care

- 2026_11_23_000001_move_post_authors_to_users remaps legacy post author IDs from admins to users. Test it against a disposable copy with representative legacy records before applying it to retained data.
- 2026_11_23_000002_enforce_product_inventory_one_to_one can create inventory rows when products shared an inventory record.
- 2026_11_23_000003_replace_demo_product_prices_with_usd updates only the five known demo SKUs and has a down() method that restores their previous sample integers.
- 2026_11_23_000004_add_catalog_query_indexes adds indexes for user role filtering and editorial sorting.

## Query and performance review

Product, post, and user list endpoints are paginated at 20 records per page. Product queries eager-load category and inventory. Product category and post foreign keys are indexed by their constraints; explicit indexes support user role filtering and post publication/creation ordering.

Search uses contains-style LIKE patterns. A conventional B-tree index does not generally accelerate a leading-wildcard search. Do not add full-text indexes or caching without representative data, EXPLAIN plans, and measured evidence.

## Contact mail

The contact endpoint requires CONTACT_TO_ADDRESS and a working Laravel Mail transport. A 202 response means the transport accepted the send operation, not that the recipient inbox received it. Verify actual inbox delivery and provider logs in the deployed environment.

## Flutter deployment boundary

The Flutter Web build is a static client and must be configured with the HTTPS API origin through API_BASE_URL. Desktop/mobile builds need a reachable API origin for the device or machine. Build and verify each agreed target separately: Android, Web, Windows, and Linux.
