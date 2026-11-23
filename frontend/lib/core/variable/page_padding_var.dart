import 'package:flutter/material.dart';
import 'package:sculpture_shop/core/theme/design_tokens.dart';

/// Shared responsive page gutters for public and admin screens.
EdgeInsets getResponsivePadding(BuildContext context, double screenWidth) {
  final width = screenWidth.isFinite && screenWidth > 0
      ? screenWidth
      : MediaQuery.sizeOf(context).width;
  final horizontal = switch (width) {
    < AppBreakpoints.mobile => 16.0,
    < AppBreakpoints.tablet => 24.0,
    < AppBreakpoints.desktop => 36.0,
    _ => ((screenWidth - AppBreakpoints.contentMaxWidth) / 2)
        .clamp(48.0, double.infinity)
        .toDouble(),
  };

  return EdgeInsets.fromLTRB(
    horizontal,
    width < AppBreakpoints.mobile ? 12 : 24,
    horizontal,
    0,
  );
}
