# ADR 0005: Exclude transactional checkout from the current portfolio scope

- Status: Accepted
- Date: 2026-11-23

## Context

The repository contains legacy cart, shopping-session, order, order-item, and payment-metadata tables, but the agreed product goal is a portfolio-quality storefront, editorial experience, and admin/API demonstration rather than a production commerce system.

## Decision

Do not expose or claim cart, checkout, order placement, fulfillment, or payment processing as implemented. Retain the legacy schema for compatibility and document it as unused by the current user-facing flows.

## Consequences

- Product deletion checks legacy cart/order references before deleting a catalog record.
- API and portfolio documentation explicitly state the scope boundary.
- A future transactional flow requires a separate design, threat model, payment-provider review, and test plan.
