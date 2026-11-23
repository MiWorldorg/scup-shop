# Contributing to Scup-Shop

Thank you for taking an interest in Scup-Shop.

Scup-Shop is currently a private, solo-developed portfolio project. Contributions are not broadly open at this stage; this document records the expected workflow for invited collaborators and future contributors.

## Before making a change

1. Read the root [README](README.md) and the relevant documentation under `docs/`.
2. Check the project scope. Cart, checkout, order placement, and payment processing are explicitly out of scope.
3. Search existing issues and pull requests before proposing duplicate work.
4. For substantial changes, discuss the approach before implementation.

## Development principles

- Keep Flutter presentation, feature state, API access, and Laravel application workflows separated.
- Preserve the existing API versioning and authorization boundaries.
- Prefer focused, reviewable changes over broad unrelated refactors.
- Keep responsive behavior in mind across Android, Web, Windows, and Linux.
- Do not commit credentials, local environment files, generated build output, or private user data.
- Update documentation when behavior, configuration, or project scope changes.

## Branches and pull requests

- Create a focused branch from the agreed development base.
- Use clear, imperative commit messages.
- Open a draft pull request while work is in progress.
- Explain the motivation, implementation, and any trade-offs.
- Include screenshots for user-visible changes when practical.
- Do not merge without explicit maintainer approval.

## Verification

Run the checks relevant to the changed area and report the exact commands and outcomes in the pull request. Never describe a check as passing unless it was actually run.

For final project-wide verification, follow [docs/testing.md](docs/testing.md) and [docs/release-checklist.md](docs/release-checklist.md).

## Reporting issues

Use the repository issue templates where available. Include reproducible steps, expected and actual behavior, environment details, and screenshots or logs with secrets removed.
