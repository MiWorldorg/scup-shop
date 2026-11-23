# GitHub presentation guide

This guide keeps the repository's GitHub-facing identity consistent with the Scup-Shop visual direction: premium, gallery-led, warm neutral materials, and restrained presentation.

## Repository About

Use this description in the repository's **About** panel:

> A premium sculpture storefront and editorial platform built with Flutter, Laravel 13, and MySQL.

Suggested topics (GitHub allows up to 20):

`flutter` · `dart` · `laravel` · `php` · `mysql` · `getx` · `rest-api` · `laravel-passport` · `responsive-design` · `sculpture` · `art-gallery` · `digital-gallery` · `portfolio-project`

Do not add `e-commerce` as a claim of completed checkout functionality; the current scope is catalog and editorial presentation, not transactional commerce.

## Visual system

- **Primary mood:** premium classical art gallery.
- **Palette:** charcoal / near-black, warm ivory, sandstone, muted bronze.
- **Composition:** artwork first, generous negative space, minimal decoration.
- **Typography:** restrained serif display paired with clean sans-serif supporting text.
- **Voice:** precise, calm, editorial; avoid exaggerated marketing claims.

## Social preview

Recommended social preview canvas: **1280 × 640 px**.

Use the supplied Scup-Shop identity as the focal artwork, with a dark charcoal field, warm bronze/stone accents, and only two text elements:
- `SCUP-SHOP`
- `A sculpture & editorial platform`

Keep important artwork and type inside the central safe area so the preview remains legible when cropped. Avoid badges, feature lists, tiny text, and fake status indicators.

The social preview image is configured in GitHub repository settings; it is not automatically read from the README.

## Manual GitHub settings

The connected GitHub editing interface can update repository files and pull requests, but does not expose the repository About metadata or social-preview setting. After the presentation pull request is reviewed:

1. Open the repository on GitHub.
2. In the **About** panel, choose the gear icon.
3. Paste the description above.
4. Add the suggested topics.
5. Save changes.
6. Open **Settings → General → Social preview** and upload the prepared 1280 × 640 image.

Keep the repository private while the project is still under development and before its assets, licensing, and release checks are reviewed.

## Honest presentation checklist

- [ ] Description and topics are set in GitHub About.
- [ ] Social preview is uploaded.
- [ ] Final app screenshots are captured from real Android, Web, Windows, and Linux runs.
- [ ] Demo URL is added only after a real deployment is available.
- [ ] CI badges are added only after the workflow has actually passed.
- [ ] License is added only after ownership and third-party asset rights are reviewed.
