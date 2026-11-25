# ADR 0004: Store demo catalog prices as whole-dollar USD integers

- Status: Accepted
- Date: 2026-11-23

## Context

The agreed portfolio currency is USD, while the legacy demo catalog contained large integer values displayed as Toman. There is no reliable exchange-rate source, effective date, or rounding policy attached to those legacy values.

## Decision

Replace the five known portfolio demo SKU prices with explicit illustrative whole-dollar USD values. Keep the existing integer products.price column; interpret its values as whole USD for this portfolio catalog. Update the seeder and add a reversible data migration for the five known SKUs. The storefront and admin UI display a dollar symbol and grouped digits.

## Consequences

- No exchange-rate conversion is claimed.
- Existing demo SKUs are updated by the migration; unrelated product rows are not changed.
- New products must be entered as whole-dollar USD values.
- Prices are portfolio sample values, not external market valuations.
- The schema does not represent fractional cents; introduce a decimal/minor-unit money model only if a future scope requires it.
