# Database

Laravel migrations in `backend/database/migrations/` are the source of truth for the schema. Run `php artisan migrate --seed` from the `backend/` directory to create the tables and add the demo product catalog.

`ProductSeeder` is safe to run repeatedly. It creates the `Sculptures` and `Collectibles` categories and five sample products using images bundled in `frontend/assets/images/products/`. `DatabaseSeeder` also creates a local demo admin account when `APP_ENV=local`.

## Application tables

| Area | Tables |
| --- | --- |
| Catalog | `products`, `product_categories`, `product_inventories` |
| Editorial | `posts`, `post_categories`, `admins` |
| Customers and orders | `users`, `user_addresses`, `user_payments`, `shopping_sessions`, `cart_items`, `orders`, `order_items` |
| Laravel and Passport | `migrations`, `sessions`, `cache`, `cache_locks`, `jobs`, `failed_jobs`, `job_batches`, and OAuth tables |

The old SQL/PDF export is not included. It contained environment-specific database naming and Persian content; the migrations and this guide provide a clean setup path for a public repository.
