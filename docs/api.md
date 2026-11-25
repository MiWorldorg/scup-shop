# API Reference

Base path: /api/v1  
Content type: application/json  
Authentication: Laravel Passport bearer token for protected endpoints.

All paths below are relative to the base path unless explicitly stated. The API is versioned under /api/v1. Admin endpoints require both a valid bearer token and the admin role.

## Response envelope

Successful non-paginated responses use:

    {
      "code": 1,
      "message": "Human-readable result.",
      "data": {}
    }

Errors use code 2 and a message. Validation errors include an errors object and return HTTP 422. Paginated Laravel Resource responses are nested under the outer data field:

- data.data: current page records
- data.links: pagination links
- data.meta: current page, last page, per-page count, and totals

The default page size for product, post, and user list queries is 20.

## Authentication

| Method | Path | Auth | Purpose |
| --- | --- | --- | --- |
| POST | /login | Public; 5 requests/minute | Issue a Passport access token |
| POST | /register | Public; 5 requests/minute | Create a regular user and issue a token |
| POST | /logout | Bearer token | Revoke the current token |
| GET | /me | Bearer token | Return the authenticated user's basic profile |

### POST /login

Request fields: email, password.

Success data includes id, username, first_name, last_name, email, role, and token. Invalid credentials return 401.

### POST /register

Required fields: username, first_name, last_name, phone, address, email, password, password_confirmation. Passwords require at least 12 characters with letters, mixed case, numbers, and symbols. Public registration always creates a regular user; it cannot self-assign admin.

## Public catalog

| Method | Path | Query | Purpose |
| --- | --- | --- | --- |
| GET | /product | page, category_id, search | Paginated product catalog |
| GET | /product/categories | — | Product category list |
| GET | /post | page | Paginated published posts |
 
Product search matches name, SKU, and description. category_id filters by product category. Product records include category and inventory details. The price field is a whole-dollar USD integer.

## Contact

### POST /contact

Public endpoint, limited to 5 requests per minute.

Required JSON fields:

- first_name: string, maximum 80 characters
- last_name: string, maximum 80 characters
- email: valid email address, maximum 255 characters
- message: 10–5,000 characters
- website: optional honeypot field; must be empty when supplied

Example request:

    {
      "first_name": "Alex",
      "last_name": "Morgan",
      "email": "alex@example.test",
      "message": "I would like to learn more about the Marble Thinker.",
      "website": ""
    }

When CONTACT_TO_ADDRESS is missing/invalid or mail sending fails, the API returns HTTP 503. On successful mail transport submission, it returns HTTP 202. A 202 means the configured transport accepted the message; it is not independent proof that the recipient inbox received it. Messages are not persisted.

## Administrator endpoints

All routes below require a bearer token and the admin role.

### Products

| Method | Path | Purpose |
| --- | --- | --- |
| GET | /admin/product | Paginated products; supports page, category_id, and search |
| GET | /admin/product/categories | Product categories |
| POST | /admin/product/create | Create product and inventory |
| PUT | /admin/product/update | Update product and optional inventory quantity |
| DELETE | /admin/product/delete | Delete product by id when no legacy cart/order references exist |

Create fields: name, desc, sku, category_id, price, optional quantity, optional image. price is a non-negative whole-dollar USD integer. image must be a bundled product asset path under assets/images/products/ with png, jpg, jpeg, or webp extension.

Example request:

    {
      "name": "Marble Thinker",
      "desc": "A contemplative figure carved in a warm marble finish.",
      "sku": "SC-THINK-001",
      "category_id": 1,
      "price": 1250,
      "quantity": 8,
      "image": "assets/images/products/marble-think.png"
    }

Update requires id and accepts the corresponding fields as partial updates. Inventory quantity is a non-negative integer. Delete request requires id. A product referenced by legacy cart/order rows cannot be deleted and returns 409.

### Posts

| Method | Path | Purpose |
| --- | --- | --- |
| GET | /admin/post | Paginated posts; supports page and search |
| GET | /admin/post/categories | Post categories |
| POST | /admin/post/create | Create post |
| PUT | /admin/post/update | Update post |
| DELETE | /admin/post/delete | Delete post by id |

Create fields: category_id, slug, title, summary, content; published and post_picture are optional. Update requires id and accepts partial updates. post_picture must be a bundled asset path under assets/images/posts/. A null published value represents an unpublished/draft post in the current application logic.

Public GET /post returns published posts only.

### Users and roles

| Method | Path | Query/body | Purpose |
| --- | --- | --- | --- |
| GET | /admin/user | page, search, role | Paginated user list |
| PUT | /admin/user/role | id, role | Change a user's role to user or admin |

The API protects against self-demotion and removing the final administrator. Role changes are limited to the admin endpoint.

## Common HTTP status codes

| Status | Meaning |
| --- | --- |
| 200 | Successful read/update/action |
| 201 | Resource created |
| 202 | Contact message accepted by configured mail transport |
| 401 | Unauthenticated or invalid credentials |
| 403 | Authenticated but not authorized |
| 404 | Resource or route not found |
| 409 | Product cannot be deleted because legacy references exist |
| 422 | Request validation failed |
| 429 | Rate limit exceeded |
| 503 | Contact mail service is not configured or sending failed |

## Notes

- The API does not expose a working cart, checkout, order placement, or payment endpoint.
- Admin asset fields accept paths to bundled assets; arbitrary binary file upload is not implemented.
- API responses include baseline content-type, frame, referrer, and permissions policy headers. HSTS is added only for secure production requests.
- API behavior and examples are documented from source inspection. They remain subject to the final automated and runtime QA phase.
