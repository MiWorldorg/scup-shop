# Database

Laravel migrations in backend/database/migrations/ are the source of truth for the schema. From backend/, run php artisan migrate --seed to create the schema and seed the portfolio catalog. Review migration notes before applying migrations to any database containing retained data.

## Entity relationship diagram

    users 1 ----- * user_addresses
      |  \
      |   \----- * user_payments 1 ----- * orders 1 ----- * order_items * ----- 1 products
      |                                  ^
      |                                  |
      |                             shopping_sessions 1 ----- * cart_items * ----- 1 products
      |
      \----- * posts * ----- 1 post_categories

    product_categories 1 ----- * products * ----- 1 product_inventories
    (one-to-one inventory ownership is enforced by a unique constraint)

The diagram shows the legacy order/cart schema relationships as well as active catalog and editorial relationships. It does not imply that cart, checkout, orders, or payment workflows are implemented.

## Application tables

| Table | Purpose | Current use |
| --- | --- | --- |
| users | Customer and administrator accounts | Active authentication and role management |
| posts | Editorial entries | Active public reading and admin CRUD |
| post_categories | Editorial categories | Active post categorization |
| products | Catalog items, SKU, image, category, inventory link, integer USD price | Active public catalog and admin CRUD |
| product_categories | Product categories | Active catalog filters |
| product_inventories | Quantity per product | Active stock display and admin editing |
| user_addresses | Saved address records | Legacy schema; no current checkout flow |
| user_payments | Payment-provider metadata | Legacy schema; no payment processing |
| shopping_sessions | Cart/session totals | Legacy schema; no current cart flow |
| cart_items | Cart line items | Legacy schema; no current cart flow |
| orders | Order headers | Legacy schema; no order placement flow |
| order_items | Order line items | Legacy schema; no order placement flow |
| admins | Legacy administrator table | No longer the active identity table for post authors |
| OAuth tables | Laravel Passport token/client persistence | Active authentication infrastructure |
| Laravel support tables | Cache, jobs, sessions, migrations, etc. | Framework infrastructure |

Contact messages are sent through Laravel Mail and are not persisted in a contact_messages table.

## Important relationships and constraints

- users has many posts; posts.author_id references users.id after migration 2026_11_23_000001_move_post_authors_to_users.
- post_categories has many posts through posts.category_id.
- product_categories has many products through products.category_id.
- products references product_inventories through inventory_id. Migration 2026_11_23_000002_enforce_product_inventory_one_to_one enforces unique inventory ownership.
- products.sku and posts.slug are unique business identifiers.
- cart_items references shopping_sessions and products; order_items references orders and products. These relations are retained for legacy schema compatibility only.

## Currency and catalog seed data

products.price is a big integer storing whole-dollar USD amounts for the current catalog. No cents or currency conversion is performed. Migration 2026_11_23_000003_replace_demo_product_prices_with_usd updates the five known demo SKUs to illustrative prices:

| SKU | Product | Price |
| --- | --- | ---: |
| SC-THINK-001 | Marble Thinker | $1,250 |
| SC-SEAT-002 | Seated Marble Figure | $890 |
| SC-GREEK-003 | Greek Guardian | $1,650 |
| CO-BUTTERFLY-004 | Butterfly Object | $185 |
| CO-INFINITY-005 | Infinity Stone | $240 |

The migration has a down() method that restores the previous sample integer values for those five SKUs. These prices are portfolio demo values, not market valuations. New products must be entered in whole USD.

ProductSeeder is safe to rerun for the known sample SKUs: it updates their catalog attributes and inventory quantities. DatabaseSeeder also creates optional demo accounts only when APP_ENV=local and the corresponding DEMO_*_PASSWORD environment value is configured.

## Migration and seed behavior

1. Back up any database containing retained data.
2. Configure backend/.env with the intended database connection.
3. Run php artisan migrate to apply pending schema/data migrations.
4. Run php artisan db:seed to seed the demo catalog and optional local accounts.
5. Use php artisan migrate:rollback only after reviewing each migration's down() behavior and confirming a restorable backup.

The author-migration should be validated against a disposable copy containing representative legacy admin and post rows before applying to retained production data. Do not test destructive or data-transforming migrations on the only copy of important data.

## Indexes

- Primary keys are created for all application tables.
- Foreign-key indexes are provided by Laravel's foreignId/constrained definitions.
- Unique indexes protect products.sku, posts.slug, and the one-to-one products.inventory_id relationship.
- Additional filter indexes should be introduced only after query plans and real data volumes are reviewed.

## Known limitations

- The legacy order/cart/payment tables are not wired into a working checkout or payment flow.
- Contact submissions are not stored; only an email attempt is made.
- Product prices are integer whole-dollar values; fractional cents are not represented.
- The old environment-specific SQL/PDF export is not part of this repository. Migrations and seeders are the reproducible schema source.
