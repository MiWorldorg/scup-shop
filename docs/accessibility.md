# Accessibility Review Notes

## Implemented in source

- Shared Material 3 controls use a minimum 48 logical-pixel target for the primary button styles.
- Public product, editorial, and gallery images expose semantic labels.
- Landing and gallery carousels disable autoplay when the operating system requests reduced motion.
- Shared async states expose semantic live regions for loading, refresh, empty, and error messages.
- Flutter's standard focus traversal and Material interaction semantics are retained for buttons, fields, chips, and menu controls.
- Semantic design colors are centralized in core/theme/colors.dart.

## Theme contrast calculation

The following ratios are calculated from the current source color tokens using the WCAG relative-luminance contrast formula. These are static calculations, not a manual visual audit.

| Foreground | Surface #20292D | Background #111719 |
| --- | ---: | ---: |
| Primary text #F4F1E9 | 13.13:1 | 16.03:1 |
| Muted text #B8C1BF | 8.06:1 | 9.84:1 |
| Gold primary #E7BD68 | 8.38:1 | 10.23:1 |
| Teal secondary #65BDB3 | 6.69:1 | 8.17:1 |
| Error #E78383 | 5.63:1 | 6.87:1 |
| Success #83C99D | 7.63:1 | 9.31:1 |
| Border #65777C | 3.16:1 | 3.86:1 |

Filled-button foreground contrast is 9.81:1 for onPrimary/primary and 7.38:1 for onSecondary/secondary. The border token is intended for visible component boundaries and exceeds the 3:1 non-text target on the main surface.

An automated Flutter test for these thresholds is in frontend/test/theme_contrast_test.dart. It has not been executed yet.

## Manual checks still required

- Keyboard-only navigation through public and admin routes, forms, menus, dialogs, and pagination.
- Screen-reader review on Android and Web, including focus order and live announcements.
- Text scaling at 200% and narrow viewport widths.
- Visual contrast review for all contextual combinations, disabled states, overlays, and image text.
- Reduced-motion behavior on target devices.
- Windows and Linux keyboard/focus behavior.

Do not mark accessibility acceptance complete until these manual checks have been performed in the final QA phase.
