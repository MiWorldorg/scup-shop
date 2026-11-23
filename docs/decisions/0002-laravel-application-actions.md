# ADR 0002: Laravel application actions for write use cases

- **Status:** Accepted for the current modernization
- **Date:** 2026-11-23

## Context

The original API repository classes combined list queries, request validation, multi-row transactions, and HTTP response construction. Controllers also contained role-management invariants. This made use-case ownership unclear and complicated focused testing.

## Decision

Use thin controllers at the HTTP boundary. Form Requests validate input. Focused application actions own multi-step writes and transaction boundaries. Repository contracts are used for reusable read-query composition and are bound in Laravel's service container. API Resources define product and post response data.

The extracted actions are `AuthenticateUser`, `RegisterUser`, `ManageProducts`, `ManagePosts`, and `ChangeUserRole`. Repositories now return paginated query results; controllers apply resources and format the HTTP envelope.

## Consequences

- Product inventory consistency and legacy-reference checks live in one application action.
- Post lifecycle writes have a clear use-case boundary.
- Administrator-role invariants are checked inside the transaction.
- Authentication registration/token issuance remains in the existing auth repository and is tracked as a follow-up extraction.
