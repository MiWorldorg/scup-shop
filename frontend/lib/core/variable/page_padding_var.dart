import 'package:flutter/material.dart';

/// Shared responsive page gutters for public and admin screens.
EdgeInsets getResponsivePadding(BuildContext context, double screenWidth) {
  final horizontal = switch (screenWidth) {
    < 600 => 16.0,
    < 900 => 24.0,
    < 1280 => 36.0,
    _ => ((screenWidth - 1280) / 2).clamp(48.0, 160.0),
  };

  return EdgeInsets.fromLTRB(horizontal, screenWidth < 600 ? 12 : 24, horizontal, 0);
}