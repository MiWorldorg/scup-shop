# ADR 0001: Centralized Flutter dependency composition

- **Status:** Accepted for the current modernization
- **Date:** 2026-11-23

## Context

Feature pages previously constructed controllers and repositories directly. Data services also created independent GetConnect instances, which duplicated base URL and header configuration and made dependencies difficult to replace in tests.

## Decision

Use GetX as the single dependency-injection and routing mechanism. Register the shared API transport, feature services, repository implementations, and global authentication controller in `frontend/lib/app/app_bindings.dart`. Register page controllers in route bindings. Controllers depend on domain repository contracts; repository implementations receive their data services through constructors; feature services use the shared `ApiClient`.

## Consequences

- Dependency construction is visible in one composition root.
- Pages no longer own network or repository construction.
- A fake service/repository can be injected without changing widget code.
- The API origin and timeout are configured once.
- The composition root must be updated when a feature adds a new shared dependency.
