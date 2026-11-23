import 'package:flutter/material.dart';
import 'package:flutter_test/flutter_test.dart';
import 'package:sculpture_shop/core/theme/colors.dart';

double _contrastRatio(Color foreground, Color background) {
  final values = [
    foreground.computeLuminance(),
    background.computeLuminance(),
  ]..sort((a, b) => b.compareTo(a));
  return (values.first + 0.05) / (values.last + 0.05);
}

void main() {
  group('AppColors contrast', () {
    test('body and semantic text colors meet WCAG AA on dark surfaces', () {
      for (final foreground in [
        AppColors.white,
        AppColors.textMuted,
        AppColors.primary,
        AppColors.secondary,
        AppColors.error,
        AppColors.success,
      ]) {
        expect(
          _contrastRatio(foreground, AppColors.surface),
          greaterThanOrEqualTo(4.5),
        );
        expect(
          _contrastRatio(foreground, AppColors.background),
          greaterThanOrEqualTo(4.5),
        );
      }
    });

    test('interactive borders meet non-text contrast on surfaces', () {
      expect(
        _contrastRatio(AppColors.border, AppColors.surface),
        greaterThanOrEqualTo(3),
      );
    });

    test('filled button foregrounds contrast with their backgrounds', () {
      expect(
        _contrastRatio(AppColors.onPrimary, AppColors.primary),
        greaterThanOrEqualTo(4.5),
      );
      expect(
        _contrastRatio(AppColors.onSecondary, AppColors.secondary),
        greaterThanOrEqualTo(4.5),
      );
    });
  });
}
