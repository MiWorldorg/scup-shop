# ADR 0003: Use GetX for Flutter navigation and application state

- Status: Accepted
- Date: 2026-11-23

## Context

The Flutter application already uses GetX for routing, dependency registration, and reactive feature controllers. Introducing a second state-management or navigation framework during the architecture cleanup would create parallel patterns and additional maintenance overhead.

## Decision

Keep GetX as the single application approach for navigation, route bindings, dependency composition, and reactive feature state. Shared dependencies are registered through AppBindings; route-owned controllers are registered by route bindings; controllers depend on domain repository contracts.

## Consequences

- Existing team knowledge and feature code remain consistent.
- Route bindings and the application composition root have clear ownership.
- Future tests should inject fake repository contracts into controllers.
- Reconsider this choice only if measured limitations justify a migration.
